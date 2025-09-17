//
//  CarriersList.swift
//  TravelSchedule
//
//  Created by Ди Di on 07/09/25.
//

import SwiftUI


struct CarriersListView: View {
    @Bindable var viewModel: RoutesViewModel
    @Binding var selectedStationFrom: String
    @Binding var selectedStationTo: String
    @Binding var navigationPath: NavigationPath
    @Binding var showDivider: Bool
    
    var body: some View {
        VStack {
            headerView
            Spacer()
            contentView
        }
        .safeAreaInset(edge: .bottom) { filterButton }
        .toolbarRole(.editor)
        .onAppear {
            showDivider = false
            viewModel.handleOnAppear()
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    // MARK: - Subviews
    private var headerView: some View {
        Text("\(selectedStationFrom) → \(selectedStationTo)")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.primary)
            .padding()
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.filteredRoutes.isEmpty {
            emptyStateView
        } else {
            routesListView
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("Вариантов нет")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
    
    private var routesListView: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.filteredRoutes, id: \.self) { segment in
                    NavigationLink(value: Nav.segment(segment)) {
                        RowCarrierView(route: segment)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 80)
        }
    }
    
    private var filterButton: some View {
        Button {
            if viewModel.allRoutes.isEmpty, let search = viewModel.loadMockSearch() {
                viewModel.allRoutes = search.segments
                viewModel.filteredRoutes = search.segments
            }
            navigationPath.append(Nav.filtration)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.ypBlue)
                    .frame(height: 60)
                HStack(spacing: 8) {
                    Text("Уточнить время")
                        .foregroundColor(.ypWhite)
                        .font(.system(size: 17, weight: .bold))
                    if viewModel.hasActiveFilters {
                        Circle()
                            .fill(Color.ypRed)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }
}


#Preview {
    PreviewWrapper(viewModel: RoutesViewModel())
}

private struct PreviewWrapper: View {
    @State private var from = "Ташкент"
    @State private var to = "Самарканд"
    @State private var navPath = NavigationPath()
    @State private var showDivider = true
    @State private var shouldResetOnAppear = false
    @Bindable var viewModel: RoutesViewModel
    
    var body: some View {
        CarriersListView(
            viewModel: viewModel,
            selectedStationFrom: $from,
            selectedStationTo: $to,
            navigationPath: $navPath,
            showDivider: $showDivider
        )
        .onAppear {
            viewModel.allRoutes = [
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
            viewModel.filteredRoutes = viewModel.allRoutes
        }
    }
}
