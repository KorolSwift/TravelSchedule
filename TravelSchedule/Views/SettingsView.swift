//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Ди Di on 07/09/25.
//

import SwiftUI


struct SettingsView: View {
    @Binding var showDivider: Bool
    @State private var serverErrorMessage: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                SwitchToggle()
                    .padding(.top, 24)
                    .frame(height: 60)
                NavigationLink(destination: TermsView(showDivider: $showDivider)) {
                    HStack {
                        Text("Пользовательское соглашение")
                            .foregroundColor(.primary)
                            .font(.regular17)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 60)
                }
                Spacer()
                Text("Приложение использует API «Яндекс.Расписания»")
                    .font(.regular12)
                    .foregroundColor(.primary)
                Text("Версия 1.0 (beta)")
                    .font(.regular12)
                    .foregroundColor(.primary)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
            }
            .toolbarRole(.editor)
            .onAppear {
                showDivider = true
                //            showServerError("500 Internal Server Error")
            }
        }
    }
}


#Preview {
    @State var showDivider = true
    SettingsView(showDivider: $showDivider)
        .environmentObject(NetworkMonitor())
}

