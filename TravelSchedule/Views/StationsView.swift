//
//  StationsView.swift
//  TravelSchedule
//
//  Created by Ди Di on 07/09/25.
//

import SwiftUI
import Observation


struct StationsView: View {
    let city: String
    @Bindable var viewModel: StationsViewModel
    @Binding var showDivider: Bool
    @Binding var selectedStation: String
    @Binding var path: NavigationPath
    let parentViewModel: RoutesViewModel
    let isFrom: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        contentView
            .onAppear {
                showDivider = false
            }
            .navigationTitle(Constants.Texts.stationChoice)
            .toolbarRole(.editor)
            .toolbar(.hidden, for: .tabBar)
            .task(id: city) { @Sendable in
                await viewModel.loadStations(for: city)
                if isFrom {
                    parentViewModel.selectedCityFromCode = viewModel.cityCode
                } else {
                    parentViewModel.selectedCityToCode = viewModel.cityCode
                }
            }
    }
    
    private var contentView: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchString)
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxHeight: .infinity)
            } else if viewModel.isEmptyState {
                emptyStateView
            } else {
                stationsListView
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text(Constants.Errors.noStation)
                .font(.bold24)
            Spacer()
        }
    }
    
    private var stationsListView: some View {
        List {
            ForEach(viewModel.searchStations, id: \.self) { station in
                stationRow(station)
            }
        }
        .listStyle(.plain)
        .background(Color(.systemBackground))
        .scrollContentBackground(.hidden)
        .listRowBackground(Color(.systemBackground))
    }
    
    private func stationRow(_ station: String) -> some View {
        HStack {
            Text(station)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            let display = "\(city) (\(station))"
            let raw = station
            selectedStation = display
            
            let stationCode = viewModel.codes[station] ?? ""
            
            if isFrom {
                parentViewModel.selectedStationFrom = display
                parentViewModel.selectedStationFromRaw = raw
                parentViewModel.selectedStationFromCode = stationCode
                parentViewModel.selectedCityFromCode = viewModel.cityCode
            } else {
                parentViewModel.selectedStationTo = display
                parentViewModel.selectedStationToRaw = raw
                parentViewModel.selectedStationToCode = stationCode
                parentViewModel.selectedCityToCode = viewModel.cityCode
            }
            showDivider = true
            withAnimation(.easeInOut(duration: 0.15)) {
                if !path.isEmpty { path.removeLast(path.count) }
            }
        }
        .listRowSeparator(.hidden)
    }
}


#Preview {
    @State var showDivider = true
    @State var selectedStation = ""
    @State var path = NavigationPath()
    
    let stationsViewModel = StationsViewModel(stations: [
        "Казанский вокзал",
        "Курский вокзал",
        "Белорусский вокзал"
    ])
    let routesViewModel = RoutesViewModel()
    return NavigationStack(path: $path) {
        StationsView(
            city: "Москва",
            viewModel: stationsViewModel,
            showDivider: $showDivider,
            selectedStation: $selectedStation,
            path: $path,
            parentViewModel: routesViewModel,
            isFrom: true
        )
    }
    .previewLayout(.sizeThatFits)
    .padding()
}
