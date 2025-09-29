//
//  SwitchToggle.swift
//  TravelSchedule
//
//  Created by Ди Di on 20/09/25.
//

import SwiftUI


struct SwitchToggle: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        Toggle(Constants.Texts.darkMode, isOn: $isDarkMode)
            .tint(.ypBlue)
            .foregroundColor(.primary)
            .font(.regular17)
            .padding(.horizontal, 16)
    }
}


#Preview {
    SwitchToggle()
}
