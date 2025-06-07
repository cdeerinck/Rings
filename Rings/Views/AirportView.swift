//
//  AirportView.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 5/5/25.
//

import SwiftUI

struct AirportView: View {
    
    @EnvironmentObject var landable: Landable
    @State var imgScale: CGFloat = 1.0
    @State var lastScale: CGFloat = 1.0
    @State var tempSpot: CGPoint = .zero //CGPoint(x: landable.pixelX, y: landable.pixelY)
    @State var currentScale: CGFloat = 1.0
    let i: UIImage = UIImage(named: "Los Angeles SEC.tif")!
    let secBit: UIImage = UIImage(named: "Sectional Bit.jpg")!
    @Namespace var namespace
    
    var body: some View {
        
//        let _ = print(/*self.title,*/ self.namespace, terminator: " -- ")
//        let _ = Self._printChanges()
        
        VStack {
            HStack {
                VStack {
                    HStack {
                        common(label: "ICAO", fieldWidth: 80, totalWidth: 180, field: $landable.icao)
                        common(label: "Name", fieldWidth: 480, totalWidth: 550, field: $landable.name)
                        common(label: "Length", fieldWidth: 50, totalWidth: 150, field: $landable.length, formatter: nfFeet)
                    }
                    HStack {
                        common(label: "Elevation", fieldWidth: 80, totalWidth: 180, field: $landable.elev, formatter: nfFeet)
                        common(label: "Note", fieldWidth: 480, totalWidth: 550, field: $landable.note)
                        common(label: "Width", fieldWidth: 50, totalWidth: 150, field: $landable.width, formatter: nfFeet)
                    }
                }
                VStack(alignment: .center) {
                    Text("Use")
                    Toggle("", isOn: $landable.useable).frame(alignment:.center)
                }
                .frame(width: 90)
            }
            HStack {
                Button {
                    updateLocation(newLocation:CGPoint.zero)
                } label: {
                    Text("Update Location ")
                        .padding(7.0)
                        .background(Color.blue)
                        .tint(Color.white)
                        .clipShape(.capsule(style: .continuous))
                }
                Button {
                    discardLocation()
                } label: {
                    Text("Discard ")
                        .padding(7.0)
                        .background(Color.red)
                        .tint(Color.white)
                        .clipShape(.capsule(style: .continuous))
                }
            }
        }
        ZStack {
            ZoomPanView(
                image: i,
                minScale: 0.05,
                maxScale: 3.0,
                currentScale: $currentScale,
                offset: $tempSpot
            )
            .border(Color.purple, width:5.0)
            Rectangle()
                .stroke(lineWidth: 2.0)
                .fill(.red)
                .frame(maxWidth: 1, maxHeight: .infinity)
            Rectangle()
                .stroke(lineWidth: 2.0)
                .fill(.red)
                .frame(maxWidth: .infinity, maxHeight: 1)
        }
        .onAppear {
            discardLocation()
        }
    }
        
    
    //For String fields
    func common(label:String, fieldWidth:CGFloat, totalWidth:CGFloat, field:Binding<String>) -> some View {
        LabeledContent {
            TextField(label, text: field)
                    .frame(width: fieldWidth)
        } label: {
            Text(label).bold()
                .border(Color.green)
        }
        .frame(width: totalWidth)
        .border(Color.red)
    }
    
    //For Int fields
    func common(label:String, fieldWidth:CGFloat, totalWidth:CGFloat, field:Binding<Int>, formatter:NumberFormatter) -> some View {
        LabeledContent {
            TextField(label, value: field, formatter: formatter)
                    .frame(width: fieldWidth)
        } label: {
            Text(label).bold()
                .border(Color.green)
        }
        .frame(width: totalWidth)
        .border(Color.red)
    }
    
    func discardLocation() -> Void {
        // Since 0,0 is the middle of the image, to find a point, start with the mid-point, and subtract the points values.
        print("Discarding from \(tempSpot) to \(landable.location)")
        tempSpot.x = (i.size.width / 2) - landable.location.x
        tempSpot.y = (i.size.height / 2) - landable.location.y
    }
    
    func updateLocation(newLocation: CGPoint) -> Void {
        print("Update from \(landable.location) to \(tempSpot)")
        // To turn the offset into a point, do the reverse.  Start with the mid-point, and subtract the offset.
        landable.location.x = (i.size.width / 2) - tempSpot.x
        landable.location.y = (i.size.height / 2) - tempSpot.y
    }
    

}

#Preview {
    let warner = Landable("CL35","Warner Springs","Los-Angeles",33.2838889,116.667222,2880,35,70,12245.493338134676,8836.926481257557,"Gliderport.  Aerotows 7 days.")
    AirportView()
        .environmentObject(warner)
}
