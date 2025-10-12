//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Ди Di on 07/09/25.
//

import SwiftUI


struct SettingsView: View {
    @Binding var showDivider: Bool
    @State var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                SwitchToggle(isDarkMode: $viewModel.isDarkMode)
                    .padding(.top, 24)
                    .frame(height: Constants.Common.height60)
                NavigationLink(destination: TermsView(showDivider: $showDivider)) {
                    HStack {
                        Text(Constants.Texts.userAgreement)
                            .foregroundColor(.primary)
                            .font(.regular17)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: Constants.Common.height60)
                }
                Spacer()
                Text(Constants.Texts.appUsing)
                    .font(.regular12)
                    .foregroundColor(.primary)
                Text(Constants.Texts.version)
                    .font(.regular12)
                    .foregroundColor(.primary)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
            }
            .toolbarRole(.editor)
            .onAppear {
                showDivider = true
            }
        }
    }
}


#Preview {
    @State var showDivider = true
    SettingsView(showDivider: $showDivider)
}

