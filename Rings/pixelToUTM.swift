//
//  pixelToUTM.swift
//  Rings
//
//  Created by Chuck Deerinck on 6/6/25.
//

import Foundation

func pixelToUTM(x: Double, y:Double, sectional: Sectional) -> (easting:Double, northing:Double) {
    let easting = sectional.xPixelSize! * x + sectional.xAxisRotation! * y + sectional.xUpperLeft!
    let northing = sectional.yAxisRotation! * x + sectional.xPixelSize! * y + sectional.yUpperLeft!
    return (easting, northing)
}

func UTMToPixel(easting:Double, northing:Double, sectional: Sectional) -> (x: Double, y: Double) {
    let x = 0.0
    let y = 0.0
    return (x, y)
}
