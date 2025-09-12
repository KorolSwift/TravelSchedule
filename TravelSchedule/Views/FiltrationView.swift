//
//  FiltrationView.swift
//  TravelSchedule
//
//  Created by Ди Di on 08/09/25.
//

import SwiftUI


struct FiltrationView: View {
    @Binding var allRoutes: [Segment]
    @Binding var filteredRoutes: [Segment]
    @Binding var showDivider: Bool
    @State private var selectedTimes: Set<String> = []
    @State private var selectedTransfer: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Время отправления")
                    .font(Font(UIFont.sfProDisplayBold24 ?? .systemFont(ofSize: 24, weight: .bold)))
                    .padding(.horizontal, 16)
                Checkbox(
                    selectedOptions: $selectedTimes,
                    options: ["Утро 06:00 - 12:00", "День 12:00 - 18:00", "Вечер 18:00 - 00:00", "Ночь 00:00 - 06:00"]
                )
            }
            VStack(alignment: .leading, spacing: 16) {
                Text("Показывать варианты с пересадками")
                    .font(Font(UIFont.sfProDisplayBold24 ?? .systemFont(ofSize: 24, weight: .bold)))
                    .padding(.horizontal, 16)
                RadioButton(
                    selectedTransfer: $selectedTransfer,
                    transferOptions: ["Да", "Нет"]
                )
            }
            Spacer()
            if !selectedTimes.isEmpty && !selectedTransfer.isEmpty {
                Button {
                    applyFilters()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        dismiss()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.ypBlue)
                            .frame(height: 60)
                        Text("Применить")
                            .foregroundColor(.ypWhite)
                            .padding()
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .onAppear {
            showDivider = false
//            showServerError("500 Internal Server Error")
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbarRole(.editor)
    }
    
    private func applyFilters() {
        filteredRoutes = allRoutes.filter { route in
            matchesTimeFilter(route.departure) && matchesTransferFilter(route)
        }
    }
    
    func matchesTimeFilter(_ departure: String) -> Bool {
        guard !selectedTimes.isEmpty else { return true }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withTimeZone]
        guard let date = formatter.date(from: departure) else {
            return false
        }
        let hour = Calendar.current.component(.hour, from: date)
        return selectedTimes.contains { timeRange in
            switch timeRange {
            case "Утро 06:00 - 12:00": return (6..<12).contains(hour)
            case "День 12:00 - 18:00": return (12..<18).contains(hour)
            case "Вечер 18:00 - 00:00": return (18..<24).contains(hour)
            case "Ночь 00:00 - 06:00": return (0..<6).contains(hour)
            default: return false
            }
        }
    }
    
    func matchesTransferFilter(_ route: Segment) -> Bool {
        switch selectedTransfer.trimmingCharacters(in: .whitespacesAndNewlines) {
        case "Да": return route.has_transfers
        case "Нет": return !route.has_transfers
        default: return true
        }
    }
}

#Preview {
    @State var allRoutes: [Segment] = [
        Segment(
            thread: Thread(uid: "001", carrier: Carrier(title: "Afrosiyob")),
            start_date: "2025-09-10",
            departure: "2025-09-10T08:00:00+03:00",
            arrival: "2025-09-10T12:00:00+03:00",
            duration: 14400,
            has_transfers: false
        ),
        Segment(
            thread: Thread(uid: "002", carrier: Carrier(title: "УТЙ")),
            start_date: "2025-09-10",
            departure: "2025-09-10T18:30:00+03:00",
            arrival: "2025-09-10T22:30:00+03:00",
            duration: 14400,
            has_transfers: true
        )
    ]
    @State var filteredRoutes: [Segment] = []
    @State var showDivider = true
    
    return FiltrationView(
        allRoutes: $allRoutes,
        filteredRoutes: $filteredRoutes,
        showDivider: $showDivider
    )
}
