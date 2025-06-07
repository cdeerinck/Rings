//
//  ZoomPanView.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 5/26/25.
//

import SwiftUI

struct ZoomPanView: View {
    
    let image: UIImage
    let minScale: CGFloat
    let maxScale: CGFloat
    
    @Binding var currentScale:CGFloat
    @State var magnificationScale:CGFloat = 1.0
    @Binding var offset:CGPoint
    @State var lastLocation:CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: image)
                    .scaleEffect(CGSize(width: currentScale * magnificationScale,height: currentScale * magnificationScale)
                    )
                    .offset(x:offset.x * (currentScale * magnificationScale), y:offset.y * (currentScale * magnificationScale))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .contentShape(Rectangle())
                    .gesture(
                        SimultaneousGesture(
                            DragGesture()
                                .onChanged { value in
                                    if lastLocation != .zero && lastLocation != value.location {
                                        offset.x += (value.location.x - lastLocation.x) * (1.0 / currentScale )
                                        offset.y += (value.location.y - lastLocation.y) * (1.0 / currentScale )
                                        lastLocation = value.location
                                    } else {
                                        lastLocation = value.location
                                    }
                                }
                                .onEnded() {_ in
                                    lastLocation = .zero
                                }
                            ,MagnifyGesture()
                                .onChanged { value in
                                    magnificationScale = value.magnification
                                    if currentScale * magnificationScale < minScale {
                                        magnificationScale = minScale / currentScale
                                    }
                                    if currentScale * magnificationScale > maxScale {
                                        magnificationScale = maxScale / currentScale
                                    }
                                }
                                .onEnded { _ in
                                    currentScale *= magnificationScale
                                    magnificationScale = 1.0
                                    print("Scale: \(currentScale)")
                                }
                        )
                    )
                    .onTapGesture(count: 2, coordinateSpace: .local) { value in
                        print("Double click at \(CGPoint(x:value.x, y:value.y))")
                        print("Offset before: \(offset)")
                        print("Geo size: \(geometry.size)")
                        print("Distance from x center: \(value.x - (geometry.size.width / 2))")
                        print("Distance from y center: \(value.y - (geometry.size.height / 2))")
                        
                        // Fix this for scale factors
                        offset.x = offset.x - (value.x - (geometry.size.width / 2))
                        offset.y = offset.y - (value.y - (geometry.size.height / 2))
                    } //End of onTapGesture
            } // End of GeometryReader
            .clipped()
        }
    }
}

#Preview {
    
    @Previewable @State var offset:CGPoint = CGPoint.zero
    @Previewable @State var scale:CGFloat = 1.0
    
    ZoomPanView(
        image: UIImage(systemName: "photo") ?? UIImage(),
        minScale: 1.0,
        maxScale: 0.1,
        currentScale: $scale,
        offset: $offset
    )
}

