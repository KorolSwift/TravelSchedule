//
//  CitiesViewModel.swift
//  TravelSchedule
//
//  Created by Ди Di on 17/09/25.
//

import SwiftUI


@MainActor
@Observable
final class CitiesViewModel {
    var searchString: String = ""
    var cities: [String] = []
    private let network = NetworkClient.shared
    var isLoading: Bool = false
    
    init(cities: [String] = []) {
        self.cities = cities
    }

    var searchCities: [String] {
        searchString.isEmpty
        ? cities
        : cities.filter { $0.localizedCaseInsensitiveContains(searchString) }
    }
    
    var isEmptyState: Bool {
        !isLoading && searchCities.isEmpty
    }
    
    func loadCities() async {
        guard cities.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let data = try await network.fetchAvailableStationsList()
            guard let countries = data.countries else {
                self.cities = []
                return
            }
            guard let settlementsFromRussia = countries.first(where: { $0.title == "Россия" }) else {
                self.cities = []
                return
            }
            let russianSettlements = settlementsFromRussia.regions?.flatMap { $0.settlements ?? [] } ?? []
            self.cities = Array(
                Set(
                    russianSettlements
                        .compactMap { $0.title?.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
                )
            ).sorted()
        } catch is CancellationError {
        } catch {
            self.cities = []
        }
    }
}
