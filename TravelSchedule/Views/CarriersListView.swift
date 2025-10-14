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
    }
        .task(id: viewModel.currentKey) {
            await viewModel.loadRoutesIfNeeded()
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(.hidden, for: .tabBar)
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
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
                .frame(maxHeight: .infinity)
        } else if viewModel.filteredRoutes.isEmpty {
            emptyStateView
        } else {
            routesListView
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text(Constants.Errors.noRoutes)
                .font(.bold24)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
    
    private var routesListView: some View {
        ScrollView {
            LazyVStack(spacing: Constants.Common.spacing8) {
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
            Task {
                       if viewModel.allRoutes.isEmpty {
                           await viewModel.loadRoutesIfNeeded()
                       }
                       navigationPath.append(Nav.filtration)
                   }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.Common.cornerRadius24)
                    .fill(Color.ypBlue)
                    .frame(height: Constants.Common.height60)
                HStack(spacing: Constants.Common.spacing8) {
                    Text(Constants.Buttons.refineTime)
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
