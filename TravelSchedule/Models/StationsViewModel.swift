//
//  StationsViewModel.swift
//  TravelSchedule
//
//  Created by Ди Di on 17/09/25.
//

import SwiftUI


@Observable
final class StationsViewModel {
    var searchString: String = ""
    let stationList: [String]
    
    init(stations: [String]) {
        self.stationList = stations
    }
    
    var searchStations: [String] {
        if searchString.isEmpty {
            return stationList
        } else {
            return stationList.filter {
                $0.localizedCaseInsensitiveContains(searchString)
            }
        }
    }
    
    var isEmptyState: Bool {
        searchStations.isEmpty
    }
}
