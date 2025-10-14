//
//  StationsViewModel.swift
//  TravelSchedule
//
//  Created by Ди Di on 17/09/25.
//

import SwiftUI


@MainActor
@Observable
final class StationsViewModel {
    var searchString: String = ""
    var stationList: [String]
    private let network = NetworkClient.shared
    var isLoading: Bool = false
    var codes: [String: String] = [:]
    var cityCode: String = ""
    
    init(stations: [String] = []) {
        self.stationList = stations
    }

    var searchStations: [String] {
        searchString.isEmpty
        ? stationList
        : stationList.filter { $0.localizedCaseInsensitiveContains(searchString) }
    }
    
    var isEmptyState: Bool {
        !isLoading && searchStations.isEmpty
    }
    
    func loadStations(for city: String) async {
        guard stationList.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let data = try await network.fetchAllStationsList()
            guard let root = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let countries = root["countries"] as? [[String: Any]],
                  let ru = countries.first(where: { ($0["title"] as? String) == "Россия" }),
                  let regions = ru["regions"] as? [[String: Any]] else { return }

            let target = normalize(city)
            var chosenSettlement: [String: Any]?
            var partialMatchCandidates: [[String: Any]] = []
            outer: for region in regions {
                guard let settlements = region["settlements"] as? [[String: Any]] else { continue }
                for settlement in settlements {
                    let names = [
                        normalize(settlement["title"] as? String ?? ""),
                        normalize(settlement["popular_title"] as? String ?? ""),
                        normalize(settlement["short_title"] as? String ?? "")
                    ]
                    if names.contains(target) {
                        chosenSettlement = settlement
                        break outer
                    }
                    if names.contains(where: { $0.contains(target) }) {
                        partialMatchCandidates.append(settlement)
                    }
                }
            }
            
            if chosenSettlement == nil {
                chosenSettlement = partialMatchCandidates.max(by: {
                    let leftCount = ($0["stations"] as? [[String: Any]])?.count ?? 0
                    let rightCount = ($1["stations"] as? [[String: Any]])?.count ?? 0
                    return leftCount < rightCount
                })
            }
            
            guard let settlement = chosenSettlement else { return }
            
            var foundCityCode: String = ""
            if let codes = settlement["codes"] as? [String: Any],
               let yandexCode = codes["yandex_code"] as? String {
                foundCityCode = yandexCode
            } else if let code = settlement["code"] as? String {
                foundCityCode = code
            }
            
            guard !foundCityCode.isEmpty else { return }
            
            let stations = settlement["stations"] as? [[String: Any]] ?? []
            var stationNames: [String] = []
            var stationCodes: [String: String] = [:]
            
            for station in stations {
                guard let title = (station["title"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
                      !title.isEmpty else { continue }
                
                stationNames.append(title)
                
                if let codes = station["codes"] as? [String: Any] {
                    let stationCode =
                    (codes["yandex_code"] as? String) ??
                    (codes["esr_code"] as? String) ??
                    (codes["express_code"] as? String) ?? ""
                    if !stationCode.isEmpty {
                        stationCodes[title] = stationCode
                    }
                }
            }
            
            self.stationList = Array(Set(stationNames)).sorted()
            self.codes = stationCodes
            self.cityCode = foundCityCode
            
        } catch {
            self.stationList = []
            self.codes = [:]
            self.cityCode = ""
        }
    }
    
    private func normalize(_ text: String) -> String {
        var normalized = text.lowercased()
        normalized = normalized.replacingOccurrences(of: "ё", with: "е")
        normalized = normalized.trimmingCharacters(in: .whitespacesAndNewlines)
        if normalized.hasPrefix("г. ") { normalized.removeFirst(3) }
        if normalized.hasPrefix("город ") { normalized.removeFirst(6) }
        normalized = normalized.replacingOccurrences(of: #"\s*\(.*?\)"#, with: "", options: .regularExpression)
        return normalized
    }
}
