//
//  Persistence.swift
//  TravelSchedule
//
//  Created by Ди Di on 22/08/25.
//

import CoreData
import Logging


struct PersistenceController {
    static let shared = PersistenceController()
    private static let logger = Logger(label: "com.travelSchedule.coredata")

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let logger = PersistenceController.logger
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            logger.error("Ошибка сохранения preview Core Data: \(error.localizedDescription), details: \(error.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        let logger = PersistenceController.logger
        container = NSPersistentContainer(name: "TravelSchedule")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                logger.error("Ошибка инициализации Core Data: \(error.localizedDescription), details: \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
