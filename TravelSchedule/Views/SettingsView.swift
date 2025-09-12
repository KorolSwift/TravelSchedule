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
        VStack(spacing: 16) {
            if let error = serverErrorMessage {
                Image(.serverError)
                    .resizable()
                    .frame(width: 223, height: 223)
                Text("Ошибка сервера")
                    .font(Font(UIFont.sfProDisplayBold24 ?? .systemFont(ofSize: 24, weight: .bold)))
                    .multilineTextAlignment(.center)
            } else {
                Text("Настройки")
                    .font(Font(UIFont.sfProDisplayBold24 ?? .systemFont(ofSize: 24, weight: .bold)))
                Button("Показать ошибку сервера") {
                    serverErrorMessage = "500 Internal Server Error"
                }
                .padding(.top, 20)
            }
        }
        .padding()
        .toolbarRole(.editor)
        .onAppear {
            showDivider = true
//            showServerError("500 Internal Server Error")
        }
    }
}


#Preview {
    @State var showDivider = true
    SettingsView(showDivider: $showDivider)
        .environmentObject(NetworkMonitor())
}
