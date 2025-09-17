//
//  RootView.swift
//  TravelSchedule
//
//  Created by Ди Di on 07/09/25.
//

import SwiftUI


struct RootView: View {
    @State private var isActive = false
    
    var body: some View {
        Group {
            if isActive {
                TabBarView()
            } else {
                SplashView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}


#Preview {
    RootView()
}
