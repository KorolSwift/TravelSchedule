//
//  TermsView.swift
//  TravelSchedule
//
//  Created by Ди Di on 20/09/25.
//

import SwiftUI


struct TermsView: View {
    @Binding var showDivider: Bool
    
    var body: some View {
        WebView(url: URL(string: "https://yandex.ru/legal/practicum_offer/")!)
            .navigationTitle(Constants.Texts.userAgreement)
            .font(.bold17)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                showDivider = false 
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbarRole(.editor)
    }
}

#Preview {
    @State var showDivider = true
    TermsView(showDivider: $showDivider)
}
