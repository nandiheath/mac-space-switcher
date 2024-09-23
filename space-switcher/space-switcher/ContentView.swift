//
//  ContentView.swift
//  space-switcher
//
//  Created by Nandi Wong on 22/9/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var spaceChangeMonitor: SpaceManager
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button(action: {
                spaceChangeMonitor.changeSpace(spaceID: 15)
            }) {
                Text("15")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                spaceChangeMonitor.changeSpace(spaceID: 15)
            }) {
                Text("16")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                spaceChangeMonitor.changeSpace(spaceID: 106)
            }) {
                Text("106")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
