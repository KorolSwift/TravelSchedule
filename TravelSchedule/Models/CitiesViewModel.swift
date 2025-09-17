//
//  CitiesViewModel.swift
//  TravelSchedule
//
//  Created by Ди Di on 17/09/25.
//

import SwiftUI


@Observable
final class CitiesViewModel {
    var searchString: String = ""
    let cities: [String]
    
    init(cities: [String]) {
        self.cities = cities
    }
    
    var searchCities: [String] {
        if searchString.isEmpty {
            return cities
        } else {
            return cities.filter {
                $0.localizedCaseInsensitiveContains(searchString)
            }
        }
    }
    
    var isEmptyState: Bool {
        searchCities.isEmpty
    }
}
