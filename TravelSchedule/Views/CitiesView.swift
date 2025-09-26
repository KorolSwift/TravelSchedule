//
//  CitiesView.swift
//  TravelSchedule
//
//  Created by Ди Di on 07/09/25.
//

import SwiftUI


struct CitiesView: View {
    let title: String
    @Bindable var viewModel: CitiesViewModel
    @Binding var showDivider: Bool
    @Binding var selectedStation: String
    let isFrom: Bool
    @Binding var path: NavigationPath
    
    var body: some View {
        contentView
            .background(Color(.systemBackground))
            .navigationTitle("Выбор города")
            .toolbarRole(.editor)
            .toolbar(.hidden, for: .tabBar)
            .onAppear { showDivider = false }
    }
    
    // MARK: - Subviews
    private var contentView: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchString)
            if viewModel.isEmptyState {
                emptyStateView
            } else {
                citiesListView
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("Город не найден")
                .font(.bold24)
            Spacer()
        }
    }
    
    private var citiesListView: some View {
        List {
            ForEach(viewModel.searchCities, id: \.self) { city in
                cityRow(city: city)
            }
        }
        .listStyle(.plain)
        .background(Color(.systemBackground))
        .scrollContentBackground(.hidden)
        .listRowBackground(Color(.systemBackground))
    }
    
    private func cityRow(city: String) -> some View {
        NavigationLink(
            value: Nav.stations(city: city, isFrom: isFrom)
        ) {
            Text(city)
                .font(.regular17)
        }
        .listRowSeparator(.hidden)
    }
}


#Preview {
    PreviewWrapper()
}
private struct PreviewWrapper: View {
    @State private var showDivider = true
    @State private var selectedStation = ""
    @State private var navPath = NavigationPath()
    
    var body: some View {
        CitiesView(
            title: "Откуда",
            viewModel: CitiesViewModel(cities: MockData.cities),
            showDivider: $showDivider,
            selectedStation: $selectedStation,
            isFrom: true,
            path: $navPath
        )
    }
}
