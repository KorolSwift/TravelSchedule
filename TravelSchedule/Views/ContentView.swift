//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Ди Di on 22/08/25.
//

import SwiftUI
import CoreData
import OpenAPIURLSession


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            //            testFetchStations()
            //            testFetchNearestSettlement()
            //            testFetchCarrierInformation()
            //            testFetchScheduleBTWStations()
            //            testFetchScheduleByStations()
            //            testFetchStationsList()
            //            testFetchCopyrightYandexSchedules()
            //            testAvailableStationsList()
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func testFetchStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = NearestStationsService(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching stations...")
                let stations = try await service.getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )
                
                print("Successfully fetched stations: \(stations)")
            } catch {
                print("Error fetching stations: \(error)")
            }
        }
    }
    
    func testFetchNearestSettlement() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = NearestSettlementService(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching nearest settlement...")
                let settlement = try await service.getNearestSettlement(
                    lat: 50.440046,
                    lng: 40.4882367,
                    distance: 50
                )
                
                print("Successfully fetched settlement: \(settlement)")
            } catch {
                print("Error fetching settlement: \(error)")
            }
        }
    }
    
    func testFetchCarrierInformation() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = CarrierInformationService(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching carrier information...")
                let information = try await service.getCarrierInformation(
                    code: "TK",
                    system: "iata"
                )
                
                print("Successfully fetched carrier information: \(information)")
            } catch {
                print("Error fetching carrier information: \(error)")
            }
        }
    }
    
    func testFetchScheduleBTWStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = ScheduleBTWStationsService(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching schedule between stations...")
                let scheduleBTW = try await service.getScheduleBTWStations(
                    from: "c146",
                    to: "c213",
                    date: "2025-09-02"
                )
                
                print("Successfully fetched schedule between stations: \(scheduleBTW)")
            } catch {
                print("Error fetching schedule between stations \(error)")
            }
        }
    }
    
    func testFetchScheduleByStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = ScheduleByStationsServices(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching schedule by stations...")
                let scheduleByStations = try await service.getScheduleByStations(
                    station: "s9600213"
                )
                
                print("Successfully fetched schedule by stations: \(scheduleByStations)")
            } catch {
                print("Error fetching schedule by stations \(error)")
            }
        }
    }
    
    func testFetchStationsList() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = StationsListServices(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching list of stations...")
                let stationsList = try await service.getStationsList(
                    uid: "098S_7_2"
                )
                
                print("Successfully fetched list of stations \(stationsList)")
            } catch {
                print("Error fetching list of stations \(error)")
            }
        }
    }
    
    func testFetchCopyrightYandexSchedules() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = CopyrightYandexSchedulesServices(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching copyright yandex schedules..")
                let copyright = try await service.getCopyrightYandexSchedules(
                    format: "json"
                )
                
                print("Successfully fetched copyright yandex schedules \(copyright)")
            } catch {
                print("Error fetching copyright yandex schedules \(error)")
            }
        }
    }
    
    func testAvailableStationsList() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = AvailableStationsListServices(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching available stations list..")
                let availableStations = try await service.getAvailableStationsList()
                
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                
                let data = try encoder.encode(availableStations)
                let fileManager = FileManager.default
                let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsURL.appendingPathComponent("AvailableStationsList.json")
                try data.write(to: fileURL)
                
                print("✅ Successfully saved stations list to file:")
                print(fileURL.path)
                
            } catch {
                print("Error fetching available stations list \(error)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
