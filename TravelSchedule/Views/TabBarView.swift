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
            tabbar
            dividerOverlay
            if !networkMonitor.isConnected {
                noInternetOverlay
            }
            if serverErrorMessage != nil {
                serverErrorOverlay
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
    
    private var tabbar: some View {
        TabView(selection: $selectedTab) {
            TripSearchView(showDivider: $showDivider)
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
    }
    
    private var dividerOverlay: some View {
        VStack(spacing: Constants.Common.spacing0) {
            if showDivider {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            Spacer().frame(height: 49)
        }
        .allowsHitTesting(false)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    private var noInternetOverlay: some View {
        VStack(spacing: Constants.Common.spacing16) {
            Image(.noInternet)
                .resizable()
                .frame(width: Constants.Common.errorsHeight, height: Constants.Common.errorsHeight)
            Text(Constants.Errors.noInternet)
                .font(.bold24)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .zIndex(3)
    }
    
    private var serverErrorOverlay: some View {
        VStack(spacing: Constants.Common.spacing16) {
            Image(.serverError)
                .resizable()
                .frame(width: Constants.Common.errorsHeight, height: Constants.Common.errorsHeight)
            Text(Constants.Errors.serverError)
                .font(.bold24)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .zIndex(4)
    }
}


#Preview {
    TabBarView()
        .environmentObject(NetworkMonitor())
}
