//
//  Calcs.swift
//  Sectional Rings
//
//  Created by Chuck Deerinck on 4/9/25.
//
//  Tweaked by Cursor on 6/4/2025

import Foundation
import SwiftUICore

func lambertConformalConic(lat: Double, lon: Double, testing:Bool = false) -> (x: Double, y: Double) {
    
    let φ:Double = Angle(degrees: lat).radians // Convert decimal degrees into radians
    let λ:Double = Angle(degrees: lon).radians
    
    var φ1:Double = 0.0, φ2:Double = 0.0, φF:Double = 0.0, λF:Double = 0.0, EF:Double = 0.0, NF:Double = 0.0, e:Double = 0.0, a:Double = 0.0
    
    if testing {
        //Givens for testing
        φ1 = Angle(degrees: 28.38333333).radians // Latitude of first standard parallel
        φ2 = Angle(degrees: 30.28333333).radians // Latitude of second standard parallel
        φF = Angle(degrees: 27.83333333).radians // Latitude of false origin
        λF = Angle(degrees:-99.0000000).radians // Longitude of false origin
        EF = 2000000 / 3.2808333333 // False Easting  // ??should be 2m US survey feet, not 2m meters.
        NF = 0 // False Northing
        
        e = 0.08227185
        a = 6378206.400
    } else {
        //Givens for this sectional from .htm file
        φ1 = Angle(degrees: 38.66666666666666).radians // Latitude of first standard parallel
        φ2 = Angle(degrees: 33.33333333333334).radians // Latitude of second standard parallel
        φF = Angle(degrees: 34.16666666666666).radians // Latitude of false origin
        λF = Angle(degrees:-118.4666666666667).radians // Longitude of false origin
        EF = 0 // False Easting
        NF = 0 // False Northing
        
        // Updated to use GRS 80 ellipsoid parameters
        a = 6378137.000000 // Semi-major axis for GRS 80
        let f = 1.0/298.257222 // Flattening for GRS 80
        e = sqrt(2*f - f*f) // Eccentricity for GRS 80
    }
    
    let m1:Double = cos(φ1) / pow(1 - pow(e,2) * pow(sin(φ1),2), 0.5)
    let m2:Double = cos(φ2) / pow(1 - pow(e,2) * pow(sin(φ2),2), 0.5)
    let t:Double = tan(Double.pi/4 - φ/2)/pow((1-e*sin(φ))/(1+e*sin(φ)),e/2)
    let t1:Double = tan(Double.pi/4 - φ1/2)/pow((1-e*sin(φ1))/(1+e*sin(φ1)),e/2)
    let t2:Double = tan(Double.pi/4 - φ2/2)/pow((1-e*sin(φ2))/(1+e*sin(φ2)),e/2)
    let tF:Double = tan(Double.pi/4 - φF/2)/pow((1-e*sin(φF))/(1+e*sin(φF)),e/2)
    let n:Double = (log(m1) - log(m2)) / (log(t1) - log(t2))
    let F:Double = m1 / (n * pow(t1, n))
    
    //r = a F tn for rF and r, using tF and t respectively, where rF is the radius of the parallel of latitude
    //  of the false origin
    var rF:Double = a * F * pow(tF, n) //trying this
    var r:Double = a * F * pow(t, n) //wrong answer on test
    
    //let rF:Double = a * (1 - pow(e,2)) / pow(1 - pow(e,2)*pow(sin(φ),2),3/2)  //wrong answer on test
    
    //r = 37565039.86
    //rF = 37807441.20
    r *= 3.280833  //Why does this fix it?  This is feet per meter!
    rF *= 3.280833  //Why does this fix it?
    
    let θ:Double = n * (λ - λF)
    
    let E = EF + r * sin(θ)
    let N = NF + rF - r * cos(θ)

    // Convert to US survey feet here, after the projection calculation
    let E_feet = E * 3.280833
    let N_feet = N * 3.280833

    let x = (16580.0/2) + (E_feet / 455.74) //Was 16645 / 2
    let y = (13120.0/2) - (N_feet / 455.74) //Was 12349 / 2

    if testing || true {
        print("---------------------")
        print(" Ellipsoid a = ", a)
        print("Ellipsoid e = ", e)
        print("Latitude of false origin = ", φF)
        print("Longitude of false origin = ", λF)
        print("Latitude of 1st standard parallel = ", φ1)
        print("Latitude of 2nd standard parallel = ", φ2)
        print("Easting of False Origin = ", EF, " or ", EF * 3.280833333, " US survey feet")
        print("Northing at false origin = ", NF, " or ", NF * 3.280833333, " US survey feet")
        
        print("Latitude = ", φ)
        print("Longitude = ", λ)

        print("m1 = ", m1)
        print("m2 = ", m2)
        print("t = ", t)
        print("tF = ", tF)
        print("t1 = ", t1)
        print("t2 = ", t2)
        print(" n = ", n)
        print(" F = ", F)
        print("r = ", r)
        print("rF = ", rF)
        print("θ = ", θ)
        print("Easting = ", E, " or ", E/3.2808333333, " US survey feet")
        print("Northing = ", N, " or ", N/3.2808333333, "US survey feet")
        print("x(0-16645) = ", x, " y(0-12349) = ", y)
    }

    
    return (x:x, y:y)
}
/*
 Spatial_Data_Organization_Information:
 Direct_Spatial_Reference_Method: Raster
 Raster_Object_Information:
 Raster_Object_Type: Pixel
 Row_Count: 12349
 Column_Count: 16645
 Spatial_Reference_Information:
 Horizontal_Coordinate_System_Definition:
 Planar:
 Map_Projection:
 Map_Projection_Name: Lambert Conformal Conic
 Lambert_Conformal_Conic:
 Standard_Parallel: 38.66666666666666
 Standard_Parallel: 33.33333333333334
 Longitude_of_Central_Meridian: -118.4666666666667
 Latitude_of_Projection_Origin: 34.16666666666666
 False_Easting: 0.000000
 False_Northing: 0.000000
 Planar_Coordinate_Information:
 Planar_Coordinate_Encoding_Method: Row and column
 Coordinate_Representation:
 Abscissa_Resolution: 42.335031
 Ordinate_Resolution: 42.335971
 Planar_Distance_Units: Meters
 Geodetic_Model:
 Horizontal_Datum_Name: North American Datum of 1983
 Ellipsoid_Name: Geodetic Reference System 80
 Semi-major_Axis: 6378137.000000
 Denominator_of_Flattening_Ratio: 298.257222
 */
/*
    Check        Ellipsoid: Clarke 1866 a = 6378206.400 metres = 20925832.16 US survey feet
                    1/f = 294.97870
    Check         then e = 0.08227185 e2 = 0.00676866
    Check        Latitude of false origin ϕF 27°50'00"N = 0.48578331 rad
    Check        Longitude of false origin λF 99°00'00"W = -1.72787596 rad
    Check        Latitude of 1st standard parallel ϕ1 28°23'00"N = 0.49538262 rad
    Check        Latitude of 2nd standard parallel ϕ2 30°17'00"N = 0.52854388 rad
    Check        Easting at false origin EF 2000000.00 US survey feet
    Check        Northing at false origin NF 0.00 US survey feet
            Forward calculation for:
    Check        Latitude ϕ = 28°30'00.00"N = 0.49741884 rad
    Check        Longitude λ = 96°00'00.00"W = -1.67551608 rad
            first gives :
    Check        m1 = 0.88046050 m2 = 0.86428642
    Check        t = 0.59686306 tF = 0.60475101
    Check        t1 = 0.59823957 t2 = 0.57602212
    Check        n = 0.48991263 F = 2.31154807
    Both Wrong        r = 37565039.86 rF = 37807441.20      r is giving 11449847 and rF is giving 6349707
    Check        θ = 0.02565177
    Wrong        Then Easting E = 2963503.91 US survey feet  //when i force r and rF, this stays wrong
    Wrong        Northing N = 254759.80 US survey feet  //when I force r and rF, this becomes correct.
*/

/*
 ---------------------
Check   Ellipsoid a =  6378206.4
Check   Ellipsoid e =  0.08227185
Check   Latitude of false origin =  0.48578330841357736
Check   Longitude of false origin =  -1.7278759594743862
Check   Latitude of 1st standard parallel =  0.4953826192995462
Check   Latitude of 2nd standard parallel =  0.5285438750874385
Check~  Easting of False Origin =  609601.219208632  or  1999999.9998171197  US survey feet
Check   Northing at false origin =  0.0  or  0.0  US survey feet
Check   Latitude =  0.49741883681838395
Check   Longitude =  1.6755160819145565
Check   m1 =  0.8804604999224146
Check   m2 =  0.8642864151462
Check   t =  0.5968630629230569
Check   tF =  0.6047510070571308
Check   t1 =  0.5982395708802095
Check   t2 =  0.5760221243104047
Check   n =  0.48991263017652986
Check   F =  2.3115480734276495
Check   r =  37565036.04628089
Check   rF =  37807437.357812725
Wrong   θ =  1.667364746518726
?       Easting =  37999617.72574022  or  11582306.647536589  US survey feet
?       Northing =  41429397.9870408  or  12627705.761989858 US survey feet
        x(0-16645) =  886283.0621267145  y(0-12349) =  -848686.7332453902
        (x: 886283.0621267145, y: -848686.7332453902)
 
        22,830 feet per pixel, if 300dpi
 */

import Foundation
import CoreLocation

struct LCCParameters {
    
    let lat0: Double = Angle(degrees: 34.16666666666666).radians          // Latitude of origin (φ0)
    let lon0: Double = Angle(degrees:-118.4666666666667).radians          // Central meridian (λ0)
    let lat1: Double = Angle(degrees: 38.66666666666666).radians          // First standard parallel (φ1)
    let lat2: Double = Angle(degrees: 33.33333333333334).radians          // Second standard parallel (φ2)
    let falseEasting: Double = 0.0
    let falseNorthing: Double = 0.0
    let radius: Double = 6371000   // Earth radius in meters (mean value ≈ 6371000)
}

func lambertConformalConic(lat: Double, lon: Double, params: LCCParameters) -> (x: Double, y: Double) {
    // Convert degrees to radians
    func deg2rad(_ degrees: Double) -> Double {
        return degrees * .pi / 180
    }

    let φ = deg2rad(lat)
    let λ = deg2rad(lon)
    let φ0 = deg2rad(params.lat0)
    let λ0 = deg2rad(params.lon0)
    let φ1 = deg2rad(params.lat1)
    let φ2 = deg2rad(params.lat2)

    // Calculate n
    let n = log(cos(φ1) / cos(φ2)) / log(tan(.pi / 4 + φ2 / 2) / tan(.pi / 4 + φ1 / 2))

    // Calculate F
    let F = (cos(φ1) * pow(tan(.pi / 4 + φ1 / 2), n)) / n

    // Calculate ρ
    let ρ = params.radius * F / pow(tan(.pi / 4 + φ / 2), n)
    let ρ0 = params.radius * F / pow(tan(.pi / 4 + φ0 / 2), n)

    // Calculate X and Y
    let x = ρ * sin(n * (λ - λ0)) + params.falseEasting
    let y = ρ0 - ρ * cos(n * (λ - λ0)) + params.falseNorthing
    
    if true {
        print("---------------------")
        //print(" Ellipsoid a = ", a)
        //print("Ellipsoid e = ", e)
        print("Latitude of false origin = ", params.lat0)
        print("Longitude of false origin = ", params.lon0)
        print("Latitude of 1st standard parallel = ", φ1)
        print("Latitude of 2nd standard parallel = ", φ2)
        print("Easting of False Origin = ", params.falseEasting, " or ", params.falseEasting * 3.280833333, " US survey feet")
        print("Northing at false origin = ", params.falseNorthing, " or ", params.falseNorthing * 3.280833333, " US survey feet")
        
        print("Latitude = ", φ)
        print("Longitude = ", λ)

        //print("m1 = ", m1)
        //print("m2 = ", m2)
        //print("t = ", t)
        //print("tF = ", tF)
        //print("t1 = ", t1)
        //print("t2 = ", t2)
        print(" n = ", n)
        print(" F = ", F)
        print("r = ", params.radius)
        //print("rF = ", rF)
        //print("θ = ", θ)
        print("ρ = ", ρ)
        print("ρ0 = ", ρ0)
        //print("Easting = ", E, " or ", E/3.2808333333, " US survey feet")
        //print("Northing = ", N, " or ", N/3.2808333333, "US survey feet")
        print("x(0-16645) = ", x, " y(0-12349) = ", y)
    }

    return (x, y)
}
