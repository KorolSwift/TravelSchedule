//
//  TabView.swift
//  TravelSchedule
//
//  Created by Ди Di on 07/09/25.
//

import SwiftUI


struct TabBarView: View {
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var selectedTab = 0
    @State private var showDivider = true
    @State private var serverErrorMessage: String? = nil
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ContentView(showDivider: $showDivider)
                    .tabItem {
                        Image(.cloud)
                            .renderingMode(.template)
                    }
                    .tag(0)
                SettingsView(showDivider: $showDivider)
                    .tabItem {
                        Image(.gear)
                            .renderingMode(.template)
                    }
                    .tag(1)
            }
            .accentColor(.primary)
            .overlay(
                VStack(spacing: 0) {
                    if showDivider {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                    }
                    Spacer().frame(height: 49)
                }
                    .allowsHitTesting(false),
                alignment: .bottom
            )
            if !networkMonitor.isConnected {
                VStack(spacing: 16) {
                    Image(.noInternet)
                        .resizable()
                        .frame(width: 223, height: 223)
                    Text("Нет интернетa")
                        .font(Font(UIFont.sfProDisplayBold24 ?? .systemFont(ofSize: 24, weight: .bold)))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .zIndex(3)
            }
            if serverErrorMessage != nil {
                VStack(spacing: 16) {
                    Image(.serverError)
                        .resizable()
                        .frame(width: 223, height: 223)
                    Text("Ошибка сервера")
                        .font(Font(UIFont.sfProDisplayBold24 ?? .systemFont(ofSize: 24, weight: .bold)))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .zIndex(4)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .serverErrorOccurred)) { note in
            serverErrorMessage = (note.userInfo?["message"] as? String) ?? ""
        }
        .onReceive(NotificationCenter.default.publisher(for: .serverErrorCleared)) { _ in
            serverErrorMessage = nil
        }
        .environmentObject(networkMonitor)
    }
}

#Preview {
    TabBarView()
        .environmentObject(NetworkMonitor())
}
