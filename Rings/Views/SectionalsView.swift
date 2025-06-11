//
//  SectionalsView.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 6/3/25.
//

import SwiftUI

struct SectionalsView: View {
    
    @EnvironmentObject var sectionals: Sectionals
    @State private var expandFav = true
    @State private var expandContUS = false
    @State private var expandAK = false
    
    var body: some View {
        VStack {
            GridRow {
                HStack {
                    Text("Name").frame(width:200)
                    Text("Current").frame(width:90)
                    Text("Next").frame(width:90)
                    Text("Favorite").frame(width:70)
                    Text("Keep Current").frame(width:90)
                    Text("Status").frame(width:90)
                }
            }
            .bold()
            ScrollView {
                Section(isExpanded: $expandFav,
                        content: {
                    ForEach($sectionals.sectionals, id: \.self) { $item in
                        if item.favorite  {
                            GridRow {
                                SectionalView(sectional: $item)
                                    .environmentObject(sectionals)
                            }
                            .onTapGesture {
                                print("tap")
                            }
                        }
                    }
                },
                        header: { SectionalHeader(label: "Favorites") }
                )
                .onTapGesture {
                    expandFav.toggle()
                }
                
                Section(isExpanded: $expandContUS,
                        content: {
                    ForEach($sectionals.sectionals, id: \.self) { $item in
                        if !item.inAK && !item.favorite {
                            GridRow {
                                SectionalView(sectional: $item)
                                    .environmentObject(sectionals)
                            }
                            .onTapGesture {
                                print("tap")
                            }
                        }
                    }
                },
                        header: { SectionalHeader(label: "Continental US & Hawaii") }
                )
                .onTapGesture {
                    expandContUS.toggle()
                }
                Section(isExpanded: $expandAK,
                        content: {
                    ForEach($sectionals.sectionals, id: \.self) { $item in
                        if item.inAK && !item.favorite {
                            GridRow {
                                SectionalView(sectional: $item)
                                    .environmentObject(sectionals)
                            }
                            .onTapGesture {
                                print("tap")
                            }
                        }
                    }
                },
                        header: { SectionalHeader(label: "Alaska").bold() }
                )
                .onTapGesture {
                    expandAK.toggle()
                }
            }
            .refreshable {
                loadSectionals(sectionals: sectionals)
            }
            .onAppear {
                sectionals.sortSectionals()
            }
        }
        
    }
}

#Preview {
    SectionalsView()
        .environmentObject(Sectionals())
}
