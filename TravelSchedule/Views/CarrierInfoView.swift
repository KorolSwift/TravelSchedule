//
//  CarrierInfoView.swift
//  TravelSchedule
//
//  Created by Ди Di on 09/09/25.
//

import SwiftUI


struct CarrierInfoView: View {
    let segment: Segment
    @Binding var showDivider: Bool
    
    var body: some View {
        Text("Информация о перевозчике")
            .onAppear {
                showDivider = false
//                showServerError("500 Internal Server Error")
            }
            .toolbarRole(.editor)
    }
}

#Preview {
    @State  var showDivider = true
    CarrierInfoView(segment: Segment(
        thread: Thread(
            uid: "12345",
            carrier: Carrier(title: "Uzbekistan Airways")
        ),
        start_date: "2025-09-02",
        departure: "2025-09-09",
        arrival: "2025-09-09T08:00:00+05:00",
        duration: 7200,
        has_transfers: true
    ), showDivider: $showDivider)
}
