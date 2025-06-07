//
//  MainView.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 5/2/25.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var globalSettings: Globals
    @EnvironmentObject var landables: Landables
    @EnvironmentObject var sectionals: Sectionals
    
    var body: some View {
        TabView {
            MapView(globalSettings: _globalSettings , sectional: Sectional(name: "Los Angeles"))
                .tabItem {
                    Image(systemName: "house")
                    Text("Map")
                }
                .environmentObject(globalSettings)
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .environmentObject(globalSettings)
            AirportListView()
                .tabItem {
                    Image(systemName: "airplane")
                    Text("Airports")
                }
                .environmentObject(landables)
            SectionalsView()
                .tabItem {
                    Image(systemName: "paperplane")
                    Text("Sectionals")
                }
                .environmentObject(sectionals)
        }
        .environmentObject(Globals())
    }
}
    

#Preview {
    MainView()
}
