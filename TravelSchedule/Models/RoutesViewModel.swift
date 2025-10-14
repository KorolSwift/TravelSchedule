//
//  RoutesViewModel.swift
//  TravelSchedule
//
//  Created by Ди Di on 17/09/25.
//

import SwiftUI
import OpenAPIURLSession
import OpenAPIRuntime
import Logging


@MainActor
@Observable
final class RoutesViewModel {
    var path = NavigationPath()
    
    var selectedStationFrom: String = ""
    var selectedStationTo: String = ""
    var selectedStationFromCode: String = ""
    var selectedStationToCode: String = ""
    var selectedCityFromCode: String = ""
    var selectedCityToCode: String = ""
    var selectedStationFromRaw: String = ""
    var selectedStationToRaw: String = ""
    
    var hasLoadedOnce = false
    var allRoutes: [Segment] = []
    var filteredRoutes: [Segment] = []
    var selectedTimes: Set<String> = []
    var selectedTransfer: String = ""
    var shouldResetOnAppear = false
    var isLoading: Bool = false
    private let logger = Logger(label: "com.travelSchedule.cities")
    var currentKey: String {
        "\(selectedCityFromCode)|\(selectedCityToCode)|\(selectedStationFromRaw)|\(selectedStationToRaw)"
    }
    
    private var lastLoadedKey: String?
    
    var hasActiveFilters: Bool {
        !selectedTimes.isEmpty || !selectedTransfer.isEmpty
    }
    
    var canSearch: Bool {
        !selectedStationFrom.isEmpty && !selectedStationTo.isEmpty
    }
    
    func swapStations() {
        swap(&selectedStationFrom, &selectedStationTo)
        swap(&selectedStationFromCode, &selectedStationToCode)
        swap(&selectedCityFromCode, &selectedCityToCode)
        swap(&selectedStationFromRaw, &selectedStationToRaw)
    }
    
    func handleOnAppear() {
        if shouldResetOnAppear {
            filteredRoutes = allRoutes
            shouldResetOnAppear = false
        }
    }
    
    func applyFilters() {
        filteredRoutes = allRoutes.filter { route in
            matchesTimeFilter(route.departure) && matchesTransferFilter(route)
        }
    }
    
    func matchesTimeFilter(_ departure: Date?) -> Bool {
        guard !selectedTimes.isEmpty else { return true }
        guard let date = departure else { return false }
        
        let hour = Calendar.current.component(.hour, from: date)
        return selectedTimes.contains { timeRange in
            switch timeRange {
            case FilterTimeRange.morning: return (6..<12).contains(hour)
            case FilterTimeRange.day:     return (12..<18).contains(hour)
            case FilterTimeRange.evening: return (18..<24).contains(hour)
            case FilterTimeRange.night:   return (0..<6).contains(hour)
            default: return false
            }
        }
    }
    
    func matchesTransferFilter(_ route: Segment) -> Bool {
        switch selectedTransfer.trimmingCharacters(in: .whitespacesAndNewlines) {
        case "Да":  return route.hasTransfers
        case "Нет": return !route.hasTransfers
        default:    return true
        }
    }
    
    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

@MainActor
extension RoutesViewModel {
    private static let isoFormatter = ISO8601DateFormatter()
    private static let simpleFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
    
    func loadRoutes(fromCode: String, toCode: String, date: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let schedule = try await NetworkClient.shared.fetchScheduleBTWStations(
                from: fromCode,
                to: toCode,
                date: date
            )
            
            var apiSegments = schedule.segments ?? []
            
            if fromCode.hasPrefix("s") && toCode.hasPrefix("s"),
               !selectedStationFromRaw.isEmpty, !selectedStationToRaw.isEmpty {
                let fromRaw = selectedStationFromRaw.lowercased()
                let toRaw = selectedStationToRaw.lowercased()
                
                apiSegments = apiSegments.filter { seg in
                    let fromSeg = (seg.from?.title ?? "").lowercased()
                    let toSeg = (seg.to?.title ?? "").lowercased()
                    return fromSeg.contains(fromRaw) && toSeg.contains(toRaw)
                }
            }
            
            self.allRoutes = apiSegments.map { api in
                let thread = api.thread
                let carrierData = thread?.carrier
                
                let carrier = Carrier(
                    title: carrierData?.title ?? "Неизвестно",
                    code: {
                        if let codeString = carrierData?.code {
                            return Int(codeString)
                        } else {
                            return nil
                        }
                    }(),
                    codes: Carrier.CarrierCodes(
                        iata: carrierData?.codes?.iata,
                        sirena: carrierData?.codes?.sirena,
                        icao: carrierData?.codes?.icao
                    ),
                    logo: carrierData?.logo,
                    logoSvg: nil
                )
                
                let threadModel = Thread(
                    uid: thread?.uid ?? "",
                    carrier: carrier
                )
                
                return Segment(
                    thread: threadModel,
                    startDate: parseDate(api.start_date),
                    departure: api.departure,
                    arrival: api.arrival,
                    duration: Double(api.duration ?? 0),
                    hasTransfers: api.has_transfers ?? false
                )
            }
            if !self.hasActiveFilters {
                self.filteredRoutes = self.allRoutes
            }
        } catch is CancellationError {
            logger.notice("Загрузка маршрутов отменена пользователем.")
        } catch {
            logger.error("Ошибка загрузки маршрутов: \(error.localizedDescription)")
        }
    }
    
    private func parseDate(_ string: String?) -> Date? {
        guard let string else { return nil }
        return Self.isoFormatter.date(from: string) ?? Self.simpleFormatter.date(from: string)
    }
    
    func loadRoutesIfNeeded(date: String? = nil) async {
        guard !selectedCityFromCode.isEmpty,
              !selectedCityToCode.isEmpty,
              !isLoading else { return }
        
        let dateString = date ?? currentDateString()
        let key = "\(selectedCityFromCode)|\(selectedCityToCode)|\(dateString)|\(selectedStationFromRaw)|\(selectedStationToRaw)"
        guard key != lastLoadedKey else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.loadRoutes(
                    fromCode: self.selectedCityFromCode,
                    toCode: self.selectedCityToCode,
                    date: dateString
                )
            }
        }
    }
}
