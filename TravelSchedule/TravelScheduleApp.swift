//
//  TravelScheduleApp.swift
//  TravelSchedule
//
//  Created by Ди Di on 22/08/25.
//

import SwiftUI

@main
struct TravelScheduleApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(networkMonitor)
        }
    }
}


