//
//  Live_barcodeApp.swift
//  Live barcode
//
//  Created by Adam Kuhnel on 6/8/24.
//

import SwiftUI
import SwiftData

@main
struct Live_barcodeApp: App {
    
    @StateObject private var vm = AppViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ExampleRootView().environmentObject(vm).task{
                await vm.requestDataScannerAccessStatus()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
