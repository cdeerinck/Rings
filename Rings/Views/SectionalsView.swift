//
//  SectionalsView.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 6/3/25.
//

import SwiftUI

struct SectionalsView: View {
    
    @EnvironmentObject var sectionals: Sectionals
    var dateFormatter = DateFormatter()
    
    var body: some View {
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
            ForEach($sectionals.sectionals //.sorted(by: { "\($0.favorite)\($0.name)" < "\($1.favorite)(\($1.name)" })
                    , id: \.self) { $item in
                GridRow {
                    HStack {
                        Text(item.name).frame(width:200)
                        Text(item.currentEdition != nil ? dateFormatter.string(from: item.currentEdition!) : "-")
                            .frame(width:90)
                        Text(item.nextEdition != nil ? dateFormatter.string(from: item.nextEdition!) : "-")
                            .frame(width:90)
                        Toggle(item.favorite ? "❤️" : "-", isOn: $item.favorite)
                            .toggleStyle(.button)
                            //.tint(Color.white)
                            .frame(width:70)
                        Toggle(item.keepCurrent ? "⏰" : "-", isOn: $item.keepCurrent)
                            .toggleStyle(.button)
                            //.tint(Color.white)
                            .frame(width:90)
                        Text(item.status.rawValue)
                            .frame(width:90)
                        
                    }
                    .background(item.use || item.name == "Los Angeles" ? Color.yellow.opacity(0.5) : Color.white.opacity(0.5))
                }
            }
        }
        .onAppear {
            dateFormatter.dateStyle = .short
            loadSectionals(sectionals: sectionals)
        }
    }
        
}

#Preview {
    SectionalsView()
        .environmentObject(Sectionals())
}
