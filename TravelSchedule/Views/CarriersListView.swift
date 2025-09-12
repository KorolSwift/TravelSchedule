//
//  CarriersList.swift
//  TravelSchedule
//
//  Created by Ди Di on 07/09/25.
//

import SwiftUI


struct CarriersListView: View {
    @Binding var selectedStationFrom: String
    @Binding var selectedStationTo: String
    @Binding var allRoutes: [Segment]
    @Binding var filteredRoutes: [Segment]
    @Binding var navigationPath: NavigationPath
    @Binding var showDivider: Bool
    @Binding var shouldResetOnAppear: Bool
    
    var hasActiveFilters: Bool {
        return filteredRoutes.count != allRoutes.count
    }
    
    var body: some View {
        VStack {
            Text("\(selectedStationFrom) → \(selectedStationTo)")
                .font(Font(UIFont.sfProDisplayBold24 ?? .systemFont(ofSize: 24, weight: .bold)))
                .foregroundColor(.primary)
                .padding()
            Spacer()
            if filteredRoutes.isEmpty {
                Text("Вариантов нет")
                    .font(Font(UIFont.sfProDisplayBold24 ?? .systemFont(ofSize: 24, weight: .bold)))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredRoutes, id: \.self) { segment in
                            NavigationLink(value: Nav.segment(segment)) {
                                RowCarrierView(route: segment)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 80)
                }}
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                if allRoutes.isEmpty {
                    if let search = loadMockSearch() {
                        allRoutes = search.segments
                        filteredRoutes = search.segments
                    }
                }
                navigationPath.append(Nav.filtration)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.ypBlue)
                        .frame(height: 60)
                    HStack(spacing: 8) {
                        Text("Уточнить время")
                            .foregroundColor(Color.ypWhite)
                            .font(UIFont.sfProDisplayBold17 != nil ? Font(UIFont.sfProDisplayBold17!) : .system(size: 18, weight: .bold))
                        if hasActiveFilters {
                            Circle()
                                .fill(Color.ypRed)
                                .frame(width: 10, height: 10)
                        }
                    }
                }
                .padding(16)
                .padding(.bottom, 24)
            }
        }
        .toolbarRole(.editor)
        .onAppear {
            showDivider = false
            if allRoutes.isEmpty, let search = loadMockSearch() {
                allRoutes = search.segments
                filteredRoutes = search.segments
            }
            if shouldResetOnAppear {
                filteredRoutes = allRoutes
                shouldResetOnAppear = false
            }
//            showServerError("500 Internal Server Error")
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    
    func loadMockSearch() -> Search? {
        guard let url = Bundle.main.url(forResource: "search", withExtension: "json") else {
            print("Не найден файл search.json")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let search = try decoder.decode(Search.self, from: data)
            return search
        } catch {
            print("Ошибка парсинга JSON: \(error)")
            return nil
        }
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var from = "Ташкент"
    @State private var to = "Самарканд"
    @State private var navPath = NavigationPath()
    @State private var showDivider = true
    
    @State private var allRoutes: [Segment] = [
        Segment(
            thread: Thread(uid: "001", carrier: Carrier(title: "Узбекистан темир йуллари")),
            start_date: "2025-09-10",
            departure: "2025-09-10T08:00:00+03:00",
            arrival: "2025-09-10T12:00:00+03:00",
            duration: 14400,
            has_transfers: false
        ),
        Segment(
            thread: Thread(uid: "002", carrier: Carrier(title: "Afrosiyob")),
            start_date: "2025-09-10",
            departure: "2025-09-10T18:30:00+03:00",
            arrival: "2025-09-10T22:30:00+03:00",
            duration: 14400,
            has_transfers: true
        )
    ]
    @State private var filteredRoutes: [Segment] = []
    @State private var shouldResetOnAppear = false
    
    var body: some View {
        CarriersListView(
            selectedStationFrom: $from,
            selectedStationTo: $to,
            allRoutes: $allRoutes,
            filteredRoutes: $filteredRoutes,
            navigationPath: $navPath,
            showDivider: $showDivider,
            shouldResetOnAppear: $shouldResetOnAppear
        )
    }
}
