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
    // These are in the htm file
    //   Need to validate which fields vary, and which are constants
    var currentEdition: Date? // From htm file in em tag Beginning_Date in yyyymmdd format
    var nextEdition: Date? // From htm file in em tag Ending_Date + 1 in yyyymmdd format
    var rowCount: Double? // em tag Row_Count
    var coloumnCount: Double? // em gat Column_Count
    var firstStandardParallel: Double? // em tag Standard_Parallel (1st occurance)
    var secondStandardParallel: Double? // em tag Standard_Parallel (2nd occurance)
    var LatitudeofFalseOrigin: Double? // em tag Latitude_of_Projection_Origin
    var LongitudeofFalseOrigin: Double? // em tag Longitude_of_Central_Meridian
    var FalseEasting:Double? = 2000000.0 / 3.2808333333 // em tag False_Easting, but values appear to be 0
    var FalseNorthing:Double? = 0.0 // em tag False_Northing, but values appear to be 0
    var abscissaResolution: Double? // em tag Abscissa_Resolution
    var ordinateResolution: Double? // em tag Ordinate_Resolution
    var planarDistanceUnits: String? // em tag Planar_Distance_Units (verify if allways "Meters"
    var ellipsoidName: String? // emtage Ellipsoid_Name
    var ellipsoidSemiMajorAxis: Double? // em tag Semi-major_Axis
    var denominatorOfFlatteningRatio: Double? // em tag Denominator_of_Flattening_Ratio
    // These are in the TFW file
    var xPixelSize: Double? // aka A (line 1)
    var yPixelSize: Double? // aka E (line 5)
    var xAxisRotation: Double? // aka B (line 3)
    var yAxisRotation: Double? // aka D (line 2)
    var xUpperLeft: Double? // aka C (line 5)
    var yUpperLeft: Double? // aka F (line 6)
    //Posible other values to limit image bleed.
    //  Could be lat/lon limits, or x/y limits.
    
    init(name:String)
    {
        self.name = name
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
