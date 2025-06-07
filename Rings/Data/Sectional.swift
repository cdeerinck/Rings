//
//  Sectional.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 6/5/25.
//

import Foundation

struct Sectional: Hashable, Equatable {
    let id: UUID = UUID()
    let name: String
    var favorite: Bool = false
    var status: SectionalStatus = .unloaded
    var keepCurrent: Bool = false
    var use: Bool = false
    var inAK: Bool

    
    // These are in the htm file
    //   Need to validate which fields vary, and which are constants
    var currentEdition: Date? // From htm file in em tag Beginning_Date in yyyymmdd format
    var nextEdition: Date? // From htm file in em tag Ending_Date + 1 in yyyymmdd format
    var rowCount: Int = 12349 // em tag Row_Count
    var columnCount: Int = 16645 // em tag Column_Count
    var firstStandardParallel: Double = 38.66666666666666 // em tag Standard_Parallel (1st occurance)
    var secondStandardParallel: Double = 33.33333333333334 // em tag Standard_Parallel (2nd occurance)
    var LongitudeOfFalseOrigin: Double = -118.4666666666667 // em tag Longitude_of_Central_Meridian
    var LatitudeOfFalseOrigin: Double = 34.16666666666666 // em tag Latitude_of_Projection_Origin
    var FalseEasting:Double = 0.0 // em tag False_Easting, but values appear to be 0
    var FalseNorthing:Double = 0.0 // em tag False_Northing, but values appear to be 0
    var abscissaResolution: Double = 42.335031 // em tag Abscissa_Resolution
    var ordinateResolution: Double = 42.335971 // em tag Ordinate_Resolution
    var planarDistanceUnits: String = "Meters" // em tag Planar_Distance_Units (verify if allways "Meters"
    var ellipsoidName: String = "Geodetic Reference System 80" // em tag Ellipsoid_Name
    var ellipsoidSemiMajorAxis: Double = 6378137.000000 // em tag Semi-major_Axis
    var denominatorOfFlatteningRatio: Double = 298.257222 // em tag Denominator_of_Flattening_Ratio
    
    // These are in the TFW file, the defaults below are for the LA Sectional
    var xPixelSize: Double = 42.3350312379 // aka A (line 1)
    var yPixelSize: Double = -42.3359715248 // aka E (line 4)
    var xAxisRotation: Double = 0.0 // aka B (line 3)
    var yAxisRotation: Double = 0.0 // aka D (line 2)
    var xUpperLeft: Double = -350999.2901801879 // aka C (line 5)
    var yUpperLeft: Double = 277717.8196927544 // aka F (line 6)

    //Posible other values to limit image bleed.
    //  Could be lat/lon limits, or x/y limits.
    
    init(name:String, inAK: Bool = false)
    {
        self.name = name
        self.inAK = inAK
    }
    
    func description() -> String {
        return "Sectional(\"\(self.name)\",\"\(self.status)\",\"\(String(describing: self.currentEdition))\",\(String(describing: self.nextEdition)),\(self.keepCurrent)\")"
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func ==(lhs: Sectional, rhs: Sectional) -> Bool {
        return lhs.name == rhs.name
    }
}
