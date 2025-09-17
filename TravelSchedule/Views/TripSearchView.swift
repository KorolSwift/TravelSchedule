//
//  TripSearchView.swift
//  TravelSchedule
//
//  Created by Ди Di on 22/08/25.
//

import SwiftUI
import CoreData


struct TripSearchView: View {
    @Binding var showDivider: Bool
    let cities = MockData.cities
    @State private var viewModel = RoutesViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack {
                searchHeader
                if viewModel.canSearch {
                    searchButton
                }
            }
            .navigationDestination(for: Nav.self) { dest in
                navigationDestination(for: dest)
            }
        }
    }
    
    private var searchHeader: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.ypBlue)
                .frame(height: 128)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.ypWhite)
                .frame(height: 96)
                .padding(.leading, 16)
                .padding(.trailing, 68)
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    cityRow(
                        title: viewModel.selectedStationFrom.isEmpty ? "Откуда" : viewModel.selectedStationFrom,
                        isPlaceholder: viewModel.selectedStationFrom.isEmpty,
                        nav: .citiesFrom
                    )
                    cityRow(
                        title: viewModel.selectedStationTo.isEmpty ? "Куда" : viewModel.selectedStationTo,
                        isPlaceholder: viewModel.selectedStationTo.isEmpty,
                        nav: .citiesTo
                    )
                }
                .padding(.leading, 16)
                Spacer()
                swapButton
            }
        }
        .padding(16)
    }
    
    private func cityRow(title: String, isPlaceholder: Bool, nav: Nav) -> some View {
        NavigationLink(value: nav) {
            HStack {
                Text(title)
                    .foregroundColor(isPlaceholder ? .ypGray : .black)
                    .font(.system(size: 17, weight: .regular))
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
            }
            .frame(height: 48)
            .padding(.horizontal, 16)
        }
    }
    
    private var swapButton: some View {
        Button(action: {
            viewModel.swapStations()
        }) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 36, height: 36)
                Image(systemName: "arrow.2.squarepath")
                    .foregroundColor(Color.ypBlue)
            }
        }
        .padding(.trailing, 16)
    }
    
    private var searchButton: some View {
        NavigationLink(value: Nav.carriers) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.ypBlue)
                    .frame(width: 150, height: 60)
                Text("Найти")
                    .foregroundColor(.ypWhite)
                    .font(.system(size: 17, weight: .regular))
            }
        }
        .onAppear {
            showDivider = true
            //                        showServerError("500 Internal Server Error")
        }
    }
    
    @ViewBuilder
    private func navigationDestination(for dest: Nav) -> some View {
        switch dest {
        case .carriers:
            CarriersListView(
                viewModel: viewModel,
                selectedStationFrom: $viewModel.selectedStationFrom,
                selectedStationTo: $viewModel.selectedStationTo,
                navigationPath: $viewModel.path,
                showDivider: $showDivider,
            )
        case .filtration:
            FiltrationView(
                viewModel: viewModel,
                showDivider: $showDivider
            )
        case .segment(let seg):
            CarrierInfoView(segment: seg, showDivider: $showDivider)
        case .citiesFrom:
            CitiesView(
                title: "Откуда",
                viewModel: CitiesViewModel(cities: cities),
                showDivider: $showDivider,
                selectedStation: $viewModel.selectedStationFrom,
                isFrom: true,
                path: $viewModel.path
            )
        case .citiesTo:
            CitiesView(
                title: "Куда",
                viewModel: CitiesViewModel(cities: cities),
                showDivider: $showDivider,
                selectedStation: $viewModel.selectedStationTo,
                isFrom: false,
                path: $viewModel.path
            )
        case .stations(let city, let isFrom):
            StationsView(
                city: city,
                showDivider: $showDivider,
                selectedStation: isFrom ? $viewModel.selectedStationFrom : $viewModel.selectedStationTo,
                path: $viewModel.path
            )
        }
    }
}


#Preview {
    @State  var showDivider = true
    TripSearchView(showDivider: $showDivider)
}
