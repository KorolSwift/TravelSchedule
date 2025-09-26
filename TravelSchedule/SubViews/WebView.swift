//
//  WebView.swift
//  TravelSchedule
//
//  Created by Ди Di on 20/09/25.
//

import SwiftUI
import WebKit


struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}


#Preview {
    if let url = URL(string: "https://yandex.ru/legal/practicum_offer/") {
        WebView(url: url)
    }
}
