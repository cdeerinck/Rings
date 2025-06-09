//
//  ContentView.swift
//  Sectional Rings
//
//  Created by Chuck Deerinck on 4/5/25.
//

import SwiftUI
import PDFKit

struct MapView: View {
    
    @EnvironmentObject var globalSettings: Globals
    @EnvironmentObject var landables: Landables
    @State var sectional: Sectional
    @State var currentScale: CGFloat = 0.05
    
    let fromRect = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200)
    let i: UIImage = UIImage(named: "Los Angeles SEC.tif")!
    let middle:CGPoint = CGPoint(x: 16645.0 / 2, y: 12349.0 / 2)
    @State var si: UIImage = UIImage()
    @State var center:CGPoint = CGPoint.zero
    var body: some View {
        ZStack (alignment: .top) {
            ZoomPanView(image: si, minScale: 0.05, maxScale: 3.0, currentScale: $currentScale, offset: $center)
                .ignoresSafeArea(edges: .all)
                HStack {
                    Button("Render") {
                        let finishedImage = drawRings(image: i, globalSettings: globalSettings, landables: landables, sectional:sectional)
                        //add overlay
                        let overLayedImage = overlayImage(image: finishedImage)
                        si = UIImage(cgImage: overLayedImage.cgImage!/*.cropping(to:img)!*/)
                        //save file
                        saveFile(image: overLayedImage)
                    }
                    Button("Show me") {
                        print("Center: \(center), Scale: \(currentScale)")
                        print("Image size: \(si.size)")
                        print("View size: needs geometry reader")
                        //landables.append(Landable("CL35","Warner Springs","Los-Angeles",33.2838889,116.667222,2880,35,70,12245.493338134676,8836.926481257557,"Gliderport.  Aerotows 9am-5pm, 7 days per week."))
                        print(lambertConformalConic(lat: 33.2838889, lon: 116.667222, sectional: sectional))
                        print(inverseProject(x: 151041.4890186461, y: -365525.18632080796, sectional: sectional))
                    }
                    ShareLink(item: Image(uiImage: si), preview: SharePreview("Rendered Sectional Rings", image: Image("Sectional Bit.jpg")
                       ))
                }
                .background(Color.white.opacity(0.5))
            }
        }
    }

#Preview {
    let sectional:Sectional = Sectional(name: "Los Angeles")
    MapView(sectional: sectional)
        .environmentObject(Globals())
        .environmentObject(Landables())
}

