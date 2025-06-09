//
//  SectionalView.swift
//  Rings
//
//  Created by Chuck Deerinck on 6/9/25.
//

import SwiftUI

struct SectionalView: View {
    
    @EnvironmentObject var sectionals:Sectionals
    @Binding var sectional:Sectional
    
    var body: some View {
        HStack {
            Text(sectional.name)
                .frame(width:200)
            if sectional.currentEdition != nil {
                Text(sectional.currentEdition!, format: Date.FormatStyle(date: .numeric, time: .omitted))
                    .frame(width:90)
            } else { Text("-")
                    .tint(Color.black)
                    .frame(width:90)
            }
            if sectional.nextEdition != nil {
                Text(sectional.nextEdition!, format: Date.FormatStyle(date: .numeric, time: .omitted))
                    .frame(width:90)
            } else { Text("-")
                    .frame(width:90)
            }
            Toggle(sectional.favorite ? "❤️" : "-", isOn: $sectional.favorite)
                .toggleStyle(.button)
                .tint(sectional.favorite ? Color.yellow : Color.black)
                .frame(width:70)
            Toggle(sectional.keepCurrent ? "⏰" : "-", isOn: $sectional.keepCurrent)
                .toggleStyle(.button)
                .tint(sectional.keepCurrent ? Color.yellow : Color.black)
                .frame(width:90)
            Text(sectional.status.rawValue)
                .frame(width:90)
            //
        } // End HStack
        .background(sectional.use ? Color.yellow.opacity(0.5) : Color.white.opacity(0.5))
        .onTapGesture {
            print("tap inside SectionalView")
            sectionals.locked.toggle()
            sectionals.locked.toggle()
          markUse(sectionals: sectionals, name: sectional.name)
       }
    }
}

#Preview {
    

    @Previewable @State var sectional = Sectional(name:"Los Angeles", inAK: false)
    SectionalView(sectional: $sectional)
        .environmentObject(Sectionals())
}
