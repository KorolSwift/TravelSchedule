//
//  TravelScheduleApp.swift
//  TravelSchedule
//
//  Created by Ди Di on 22/08/25.
//

import SwiftUI

@main
struct TravelScheduleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
