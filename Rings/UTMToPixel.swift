//
//  UTMToPixel.swift
//  Rings
//
//  Created by Chuck Deerinck on 6/6/25.
//

import UIKit

/*
    To go from UTM(x'y') to pixel position (x,y) use

    x = (Ex' - By' + BF - EC) / (AE - DB)
    y = (-Dx' + Ay' + DC - AF) / (AE - DB)
 
    Details from: https://en.wikipedia.org/wiki/World_file

    Line 1: A: xPixelSize       Pixel size in the x-direction in the map units/pixel
    Line 2: D: yAxisRotation    Rotation about y-axis
    Line 3: B: xAxisRotation    Rotation about x-axis
    Line 4: E: yPixelSize       Pixel size in the y-direction in map units, almost always negative
    Line 5: C: xUpperLeft       x-coordinate of the center of the upper left pixel
    Line 6: F: yUpperLeft       y-coordinate of the center of the upper left pixel
 
    x' is the calculated UTM easting of the pixel on the map
    y' is the calculated UTM northing of the pixel on the map
    x is the column number of the pixel in the image counting from left
    y is the row number of the pixel in the image counting from top
    All in meters per pixel
 
*/

func UTMToPixel(easting:Double, northing:Double, sectional: Sectional) -> CGPoint {
    let x = (sectional.yPixelSize * easting // (Ex'
            - sectional.xAxisRotation * northing // -By'
            + sectional.xAxisRotation * sectional.yUpperLeft // + BF
            - sectional.yPixelSize * sectional.xUpperLeft) // - EC
            / ( sectional.xPixelSize * sectional.yPixelSize // /(AE
            - sectional.yAxisRotation * sectional.xAxisRotation) // - DB)
    let y = (-sectional.yAxisRotation * easting // (-Dx'
            + sectional.xPixelSize * northing // + Ay'
            + sectional.yAxisRotation * sectional.xUpperLeft // + DC
            - sectional.xPixelSize * sectional.yUpperLeft) // - AF)
            / ( sectional.xPixelSize * sectional.yPixelSize  // / (AE
            - sectional.yAxisRotation * sectional.xAxisRotation)  // - DB)
    return CGPoint(x:x, y:y)
}
