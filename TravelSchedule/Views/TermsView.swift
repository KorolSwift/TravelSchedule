//
//  TermsView.swift
//  TravelSchedule
//
//  Created by Ди Di on 20/09/25.
//

import SwiftUI


struct TermsView: View {
    @Binding var showDivider: Bool
    private let termsURLString = "https://yandex.ru/legal/practicum_offer/"
    
    var body: some View {
        Group {
            if let url = URL(string: termsURLString) {
                WebView(url: url)
            } else {
                Text("Не удалось открыть пользовательское соглашение.")
            }
        }
        .navigationTitle(Constants.Texts.userAgreement)
        .font(.bold17)
        .ignoresSafeArea(edges: .bottom) 
        .onAppear { showDivider = false }
        .toolbar(.hidden, for: .tabBar)
        .toolbarRole(.editor)
    }
}


#Preview {
    @State var showDivider = true
    NavigationStack {
        TermsView(showDivider: $showDivider)
    }
    .previewLayout(.sizeThatFits)
}
