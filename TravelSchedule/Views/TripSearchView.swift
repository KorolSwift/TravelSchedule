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
    @State private var viewModel = RoutesViewModel()
    @State private var selectedGroupIndex: Int? = nil
    @State private var showStories = false
    @State private var viewedStories: Set<Int> = []
    let cities = MockData.cities
    private let mockCarrierInfo = MockDataInfo.loadCarrierInfo()
    private let storyGroups = (1...6).map { index in
        StoryGroup(images: ["\(index)", "\(index).1"])
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack(spacing: 0) {
                storiesHeader
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                searchHeader
                if viewModel.canSearch {
                    searchButton
                }
                Spacer()
            }
            .navigationDestination(for: Nav.self) { dest in
                navigationDestination(for: dest)
            }
            .onAppear {
                viewModel.filteredRoutes = viewModel.allRoutes
            }
        }
    }
    
    private var storiesHeader: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<storyGroups.count, id: \.self) { index in
                    StoryPreview(
                        group: storyGroups[index],
                        title: StoryText.firstText,
                        action: {
                            selectedGroupIndex = index
                            showStories = true
                            viewedStories.insert(index)
                        },
                        isViewed: viewedStories.contains(index)
                    )
                }
            }
        }
        .fullScreenCover(isPresented: $showStories) {
            if let index = selectedGroupIndex {
                StoriesView(startGroupIndex: index, viewedStories: $viewedStories)
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
                    .font(.regular17)
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
                    .font(.regular17)
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
            CarrierInfoView(showDivider: $showDivider, route: mockCarrierInfo)
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
                viewModel: StationsViewModel(stations: MockData.stations[city] ?? []),
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
