//
//  AirportListView.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 5/2/25.
//

import SwiftUI

struct AirportListView: View {
    
    @EnvironmentObject var landables: Landables
    
    var body: some View {
        NavigationStack {
            HStack {
                
                VStack {
                    Text("ICAO")
                    Text("Elevation")
                }
                .frame(minWidth:90, maxWidth:90)
                VStack(alignment: .leading) {
                    Text("Name")
                    Text("Note")
                }
                .frame(minWidth:100, maxWidth:.infinity)
                VStack {
                    Text("Width")
                    Text("Length")
                }
                .frame(minWidth:90, maxWidth:90)
                HStack {
                    Text("Use")
                    Spacer().frame(width:15)
                }
            }
            .font(.title2)
            ScrollView {
                Grid(alignment: .leading) {
                    NavigationLink {
                        AirportView()
                            .environmentObject(landables.landables.last!)
                    } label: {
                            Text("Create New Landable")
                    }.simultaneousGesture(TapGesture().onEnded{
                        landables.landables.append(Landable("", "", "", 0.0, 0.0, 0, 0, 0, 0.0, 0.0, ""))

                    })
                    ForEach($landables.landables, id: \.self) { $item in
                        HStack {
                            NavigationLink {
                                AirportView(tempSpot: item.location)
                                    .environmentObject(item)
                            } label: {
                                
                                GridRow {
                                    //Toggle("", isOn: item.usable)
                                    HStack {
                                        VStack {
                                            Text(item.icao)
                                            Text(item.elev.description)
                                        }
                                        .frame(minWidth:90, maxWidth:90)
                                        VStack {
                                            
                                            Text(item.name)
                                                .frame(maxWidth:.infinity,alignment:.topLeading)
                                            HStack {
                                                Text(item.note).lineLimit(nil)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth:.infinity,alignment:.topLeading)
                                            }
                                        }
                                        .frame(
                                            maxWidth: .infinity,
                                            maxHeight: .infinity,
                                            alignment: .topLeading
                                        )
                                        VStack {
                                            Text(item.width.description)
                                            Text(item.length.description)
                                        }
                                        .frame(minWidth:90, maxWidth:90)
                                    }
                                }
                            }
                            HStack {
                                Toggle("", isOn: $item.useable)
                                    .frame(minWidth:60, maxWidth:60)
                                Spacer().frame(width:10)
                            }
                        }
                        Divider()
                    }
                }
            }
        }
    }
}

func isItUsable(_ landable: Landable, _ switch: inout Binding<Bool>) {
    //        let enabled = CurrentValueSubject<Bool, Never>(useable)
    //        self.useable = Binding<Bool>(
    //            get: { enabled.value },
    //            set: { enabled.value = $0 }
    //            )
}

#Preview {
    AirportListView()
        .environmentObject(Landables())
}
