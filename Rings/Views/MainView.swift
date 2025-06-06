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
            MapView()
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
        //.environmentObject(Landables())
//        Button("Lambert") {
//            print( lambertConformalConic(lat: 28.5, lon: 96.0, testing: true))
//            // Latitude ϕ = 28°30'00.00"N = 0.49741884 rad
//            // Longitude λ = 96°00'00.00"W = -1.67551608 rad
//        }
//        Button("Warner") {
//            print( lambertConformalConic(lat: 33.2845, lon: -116.6697, testing: false))
//        }
    }
}
    

#Preview {
    MainView()
}
