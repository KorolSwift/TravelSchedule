//
//  StationsView.swift
//  TravelSchedule
//
//  Created by Ди Di on 07/09/25.
//

import SwiftUI


struct StationsView: View {
    let city: String
    @Bindable var viewModel: StationsViewModel
    @Binding var showDivider: Bool
    @Binding var selectedStation: String
    @Binding var path: NavigationPath
    
    var body: some View {
        contentView
            .onAppear {
                showDivider = false
                //            showServerError("500 Internal Server Error")
            }
            .navigationTitle("Выбор станции")
            .toolbarRole(.editor)
            .toolbar(.hidden, for: .tabBar)
        
    }
    
    // MARK: - Subviews
    private var contentView: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchString)
            if viewModel.isEmptyState {
                emptyStateView
            } else {
                stationsListView
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("Станция не найдена")
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
            selectedStation = "\(city) (\(station))"
            withAnimation(.easeInOut(duration: 0.15)) {
                path.removeLast(2)
            }
        }
        .listRowSeparator(.hidden)
    }
}


#Preview {
    @State var showDivider = true
    @State var selectedStation = ""
    @State var path = NavigationPath()
    let viewModel = StationsViewModel(stations: ["Казанский вокзал", "Курский вокзал", "Белорусский вокзал"])
    
    return NavigationStack(path: $path) {
        StationsView(
            city: "Москва",
            viewModel: viewModel,
            showDivider: $showDivider,
            selectedStation: $selectedStation,
            path: $path
        )
    }
}
