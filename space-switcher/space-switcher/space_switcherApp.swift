//
//  space_switcherApp.swift
//  space-switcher
//
//  Created by Nandi Wong on 22/9/2024.
//

import SwiftUI

@main
struct space_switcherApp: App {
    // Create an instance of SpaceChangeMonitor
    @StateObject private var spaceChangeMonitor = SpaceManager()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // SpaceChangeMonitor starts when the app appears
                    spaceChangeMonitor.startMonitoring()
                    print("SpaceChangeMonitor initialized.")
                }
                .onDisappear {
                    // Optional: You can stop monitoring if necessary
                    spaceChangeMonitor.stopMonitoring()
                    print("SpaceChangeMonitor stopped.")
                }.environmentObject(spaceChangeMonitor)
        }
    }
    
    
}
