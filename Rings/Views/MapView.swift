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
    @EnvironmentObject var sectionals: Sectionals
    @EnvironmentObject var landables: Landables
    //let sectional:Sectional = sectionals.sectionals.filter({$0.use}).first!
    //@State var sectional: Sectional
    @State var currentScale: CGFloat = 0.05
    
    let fromRect = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200)
    let middle:CGPoint = CGPoint(x: 16645.0 / 2, y: 12349.0 / 2)
    //@State var si: UIImage
    @State var center:CGPoint = CGPoint.zero
    var body: some View {
        ZStack (alignment: .top) {
            ZoomPanView(image: sectionals.sectionals.filter({$0.use}).first!.image, minScale: 0.05, maxScale: 3.0, currentScale: $currentScale, offset: $center)
                .ignoresSafeArea(edges: .all)
                HStack {
                    Button("Render") {
                        //si = sectionals.sectionals.filter({$0.use}).first!.image
                        print("Rendering:", sectionals.sectionals.filter({$0.use}).first!.name)
                        let finishedImage = drawRings(image: sectionals.sectionals.filter({$0.use}).first!.image, globalSettings: globalSettings, landables: landables, sectional:sectionals.sectionals.filter({$0.use}).first!)
                        //add overlay
                        let overLayedImage = overlayImage(image: finishedImage)
                        //si = UIImage(cgImage: overLayedImage.cgImage!/*.cropping(to:img)!*/)
                        //save file
                        saveFile(image: overLayedImage)
                    }
                    Button("Show me") {
                        print("Center: \(center), Scale: \(currentScale)")
                        print("Image size: \(sectionals.sectionals.filter({$0.use}).first!.image.size)")
                        print("View size: needs geometry reader")
                        //landables.append(Landable("CL35","Warner Springs","Los-Angeles",33.2838889,116.667222,2880,35,70,12245.493338134676,8836.926481257557,"Gliderport.  Aerotows 9am-5pm, 7 days per week."))
                        let s = sectionals.sectionals.filter({$0.use}).first!
                        var spot = lambertConformalConic(lat: 33.2838889, lon: -116.667222, sectional: s)
                        let spot2 = pixelToUTM(x: spot.x, y: spot.y, sectional: s)
                        print(inverseProject(N: spot2.northing , E: spot2.easting, sectional: s))
                    }
                    ShareLink(item: Image(uiImage: sectionals.sectionals.filter({$0.use}).first!.image), preview: SharePreview("Rendered Sectional Rings", image: Image("Sectional Bit.jpg")
                       ))
                }
                .background(Color.white.opacity(0.5))
            }
        }
    }

#Preview {
    //let sectionals:Sectionals = Sectionals()
    //let sectional:Sectional = sectionals.sectionals.filter({$0.use}).first!
    MapView()
        .environmentObject(Globals())
        .environmentObject(Sectionals())
        .environmentObject(Landables())
}

