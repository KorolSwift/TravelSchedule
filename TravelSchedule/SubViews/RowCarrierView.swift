//
//  RowCarrierView.swift
//  TravelSchedule
//
//  Created by Ди Di on 08/09/25.
//

import SwiftUI


struct RowCarrierView: View {
    let imageHeight: Double = Constants.Common.height38
    let route: Segment
    
    var body: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: Constants.Common.cornerRadius24)
                .fill(Color.ypLightGray)
                .frame(height: Constants.Common.cardHeight104)
            
            VStack {
                HStack(spacing: Constants.Common.spacing16) {
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
        HStack(spacing: Constants.Common.spacing16) {
            Image(.carrier)
                .resizable()
                .scaledToFit()
                .frame(width: imageHeight, height: imageHeight)
                .cornerRadius(Constants.Common.cornerRadius12)
                .padding(.leading, 14)
            
            VStack(alignment: .leading) {
                Text(route.thread.carrier.title)
                    .font(.regular17)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(.black)
                
                if route.has_transfers {
                    Text(Constants.Texts.withTransfer)
                        .font(.regular12)
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
                .font(.regular12)
                .foregroundColor(.black)
            Spacer()
        }
        .frame(height: imageHeight)
    }
    
    private var timesBlock: some View {
        HStack(spacing: Constants.Common.spacing16) {
            Text(formatTime(route.departure))
                .foregroundColor(.black)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .font(.regular17)
            
            Text("\(Int(route.duration / 3600)) часов")
                .font(.regular12)
                .foregroundColor(.black)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
            
            Text(formatTime(route.arrival))
                .font(.regular17)
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
    let mockCarrier = Carrier(
        title: "РЖД",
        code: 123,
        codes: nil
    )
    let mockThread = Thread(uid: "028S_3_2", carrier: mockCarrier)
    let mockSegment = Segment(
        thread: mockThread,
        start_date: "2025-09-14",
        departure: "2025-09-14T12:30:00+03:00",
        arrival: "2025-09-14T18:00:00+03:00",
        duration: 19800,
        has_transfers: false
    )
    RowCarrierView(route: mockSegment)
}
