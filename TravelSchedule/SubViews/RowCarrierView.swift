//
//  RowCarrierView.swift
//  TravelSchedule
//
//  Created by Ди Di on 08/09/25.
//

import SwiftUI


struct RowCarrierView: View {
    let imageHeight: Double = 38
    let route: Segment
    
    var body: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.ypLightGray)
                .frame(height: 104)
            
            VStack {
                HStack(spacing: 16) {
                    carrierInfoBlock
                    Spacer()
                    dateBlock
                }
                timesBlock
                    .padding(.horizontal, 14)
                    .foregroundColor(.primary)
            }
        }
    }
    
    // MARK: - Subviews
    private var carrierInfoBlock: some View {
        HStack(spacing: 16) {
            Image(.carrier)
                .resizable()
                .scaledToFit()
                .frame(width: imageHeight, height: imageHeight)
                .cornerRadius(12)
                .padding(.leading, 14)
            
            VStack(alignment: .leading) {
                Text(route.thread.carrier.title)
                    .font(.system(size: 17, weight: .regular))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(.black)
                
                if route.has_transfers {
                    Text("С пересадкой")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.ypRed)
                }
            }
        }
    }
    
    private var dateBlock: some View {
        VStack {
            Text(formatDate(route.start_date))
                .padding(.trailing, 7)
                .frame(maxHeight: .infinity, alignment: .top)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.black)
            Spacer()
        }
        .frame(height: imageHeight)
    }
    
    private var timesBlock: some View {
        HStack(spacing: 16) {
            Text(formatTime(route.departure))
                .foregroundColor(.black)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .font(.system(size: 17, weight: .regular))
            
            Text("\(Int(route.duration / 3600)) часов")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.black)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
            
            Text(formatTime(route.arrival))
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.black)
        }
    }
    
    private func formatDate(_ isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ru_RU")
        
        if let date = formatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.locale = .current
            displayFormatter.setLocalizedDateFormatFromTemplate("dMMM")
            return displayFormatter.string(from: date)
        }
        return isoDate
    }
    
    private func formatTime(_ isoDateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
            .withTimeZone,
            .withColonSeparatorInTime
        ]
        
        if let date = isoFormatter.date(from: isoDateString) ??
            ISO8601DateFormatter().date(from: isoDateString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            timeFormatter.timeZone = TimeZone.current
            return timeFormatter.string(from: date)
        }
        return isoDateString
    }
}


#Preview {
    let mockCarrier = Carrier(title: "РЖД")
    let mockThread = Thread(uid: "028S_3_2", carrier: mockCarrier)
    let mockSegment = Segment(
        thread: mockThread,
        start_date: "2025-09-14T00:00:00+03:00",
        departure: "2025-09-14T12:30:00+03:00",
        arrival: "2025-09-14T18:00:00+03:00",
        duration: 19800,
        has_transfers: false
    )
    RowCarrierView(route: mockSegment)
}
