//
//  pixelToUTM.swift
//  Rings
//
//  Created by Chuck Deerinck on 6/6/25.
//

/*
    To go from pixel position (x,y) to UTM(x'y') use

    x' = Ax + By + C
    y' = Dx + Ey + F
 
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

func pixelToUTM(x: Double, y:Double, sectional: Sectional) -> (easting:Double, northing:Double) {
    let easting = sectional.xPixelSize * x + sectional.xAxisRotation * y + sectional.xUpperLeft
    let northing = sectional.yAxisRotation * x + sectional.xPixelSize * y + sectional.yUpperLeft
    return (easting, northing)
}

