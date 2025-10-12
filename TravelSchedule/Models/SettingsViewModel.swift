//
//  SettingsViewModel.swift
//  TravelSchedule
//
//  Created by Ди Di on 02/10/25.
//

import SwiftUI


@Observable
final class SettingsViewModel {
    private let darkModeKey = "isDarkMode"
    
    var isDarkMode: Bool {
        get { UserDefaults.standard.bool(forKey: darkModeKey) }
        set { UserDefaults.standard.set(newValue, forKey: darkModeKey) }
    }
    
    var serverErrorMessage: String? = nil
}
