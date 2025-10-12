//
//  TravelScheduleApp.swift
//  TravelSchedule
//
//  Created by Ди Di on 22/08/25.
//

import SwiftUI


@main
struct TravelScheduleApp: App {
    var networkMonitor = NetworkMonitor()
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
