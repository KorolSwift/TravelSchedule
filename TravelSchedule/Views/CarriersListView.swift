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
            .font(.bold24)
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
                .font(.bold24)
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
                        .font(.bold17)
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
    @Previewable @State var from = "Москва"
    @Previewable @State var to = "Санкт-Петербург"
    @Previewable @State var path = NavigationPath()
    @Previewable @State var divider = false
    
    CarriersListView(
        viewModel: RoutesViewModel(),
        selectedStationFrom: $from,
        selectedStationTo: $to,
        navigationPath: $path,
        showDivider: $divider
    )
}
