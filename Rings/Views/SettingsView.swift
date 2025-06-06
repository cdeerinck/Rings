//
//  SettingsView.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 5/2/25.
//

import SwiftUI


struct SettingsView: View {
    
    let secBit: UIImage = UIImage(named: "Sectional Bit.jpg")!

    @EnvironmentObject var globalSettings:Globals

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    Image(uiImage:secBit).resizable().aspectRatio(contentMode: .fit)
                        .frame(height:500, alignment: .leading)
                }
                VStack(spacing:0) {
                    GeometryReader { metrics in
                        HStack {
                            VStack {
                                Stepper("\(globalSettings.safety[0])%", value: $globalSettings.safety[0], in: 100...100, step:1)
                                    .frame(width:metrics.size.width*0.20)
                                Stepper("\(globalSettings.safety[1])%", value: $globalSettings.safety[1], in: 4...99, step:1)
                                    .frame(width:metrics.size.width*0.20)
                            }
                            ColorPicker("Safe Range", selection: $globalSettings.colors[0] )
                                .frame(width:metrics.size.width*0.20)
                        }
                    }
                    .frame(height:100)
                    .background(globalSettings.colors[0])
                    if globalSettings.useGradients {
                        LinearGradient(gradient: Gradient(colors: [globalSettings.colors[0], globalSettings.colors[1]]), startPoint: .top, endPoint: .bottom)
                            .frame(height:40)
                    } else {
                        VStack(spacing:0) {
                            Rectangle()
                                .fill(globalSettings.colors[0])
                                .border(Color.white, width: 0)
                                .frame(height:20)
                            Rectangle()
                                .fill(globalSettings.colors[1])
                                .border(Color.white, width: 0)
                                .frame(height:20)
                        }
                    }
                    GeometryReader { metrics in
                        HStack {
                            VStack {
                                Stepper("\(globalSettings.safety[2])%", value: $globalSettings.safety[2], in: 3...98, step:1)
                                    .frame(width:metrics.size.width*0.20)
                                Stepper("\(globalSettings.safety[3])%", value: $globalSettings.safety[3], in: 2...97, step:1)
                                    .frame(width:metrics.size.width*0.20)
                            }
                            ColorPicker("Marginal Range", selection: $globalSettings.colors[1] )
                                .frame(width:metrics.size.width*0.20)
                        }
                    }
                    .frame(height:100)
                    .background(globalSettings.colors[1])
                    if globalSettings.useGradients {
                        LinearGradient(gradient: Gradient(colors: [globalSettings.colors[1], globalSettings.colors[2]]), startPoint: .top, endPoint: .bottom)
                            .frame(height:40)
                    } else {
                        VStack(spacing:0) {
                            Rectangle()
                                .fill(globalSettings.colors[1])
                                .border(Color.white, width: 0)
                                .frame(height:20)
                            Rectangle()
                                .fill(globalSettings.colors[2])
                                .border(Color.white, width: 0)
                                .frame(height:20)
                        }
                    }
                    GeometryReader { metrics in
                        HStack {
                            VStack {
                                Stepper("\(globalSettings.safety[4])%", value: $globalSettings.safety[4], in: 1...96, step:1)
                                    .frame(width:metrics.size.width*0.20)
                                Stepper("\(globalSettings.safety[5])%", value: $globalSettings.safety[5], in: 0...95, step:1)
                                    .frame(width:metrics.size.width*0.20)
                            }
                            ColorPicker("Risky Range", selection: $globalSettings.colors[2])
                                .frame(width:metrics.size.width*0.20)
                        }
                    }
                    .frame(height:100)
                    .background(globalSettings.colors[2])
                }
            }
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text("Use Gradients")
                    HStack { // <3>
                        if globalSettings.useGradients { // <4>
                            Text("On")
                        } else {
                            Text("Off")
                        }
                        Spacer()
                        Toggle("", isOn: $globalSettings.useGradients) // <5>
                    }
                }
                .frame(width: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(globalSettings.useGradients ? Color.green: Color.red, lineWidth: 2) // <7>
                )
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Text("L/D")
                            .frame(width:100)
                        TextField("L/D", value: $globalSettings.lOverD, formatter: nfFeet)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width:100)
                    }
                    HStack {
                        Text("Pattern Altitude")
                            .frame(width:100)
                        TextField("Pattern Altitude", value: $globalSettings.patternAltitude, formatter: nfFeet)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width:100)
                    }
                    HStack {
                        Text("Range Altitude")
                            .frame(width:100)
                        TextField("Range Altitude", value: $globalSettings.elevation, formatter: nfFeet)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width:100)
                    }
                }
                Spacer()
            }
        }
        
    }
}

#Preview {
    SettingsView()
        .environmentObject(Globals())
}
