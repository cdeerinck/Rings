//
//  Calcs.swift
//  Sectional Rings
//
//  Created by Chuck Deerinck on 4/9/25.
//
//  Tweaked by Cursor on 6/4/2025

import Foundation
import SwiftUICore

func lambertConformalConic(lat: Double, lon: Double, sectional:Sectional) -> (x: Double, y: Double) {
    
    let φ:Double = Angle(degrees: lat).radians // Convert decimal degrees into radians
    let λ:Double = Angle(degrees: lon).radians

    
    //Givens for this sectional from .htm file
    let φ1 = Angle(degrees: sectional.firstStandardParallel).radians // Latitude of first standard parallel
    let φ2 = Angle(degrees: sectional.secondStandardParallel).radians // Latitude of second standard parallel
    let φF = Angle(degrees: sectional.LatitudeOfFalseOrigin).radians // Latitude of false origin
    let λF = Angle(degrees:sectional.LongitudeOfFalseOrigin).radians // Longitude of false origin
    let EF = sectional.FalseEasting // False Easting
    let NF = sectional.FalseNorthing // False Northing
    
    // Get the ellipsoid parameters for the Sectional
    let a = sectional.ellipsoidSemiMajorAxis // Semi-major axis for GRS 80
    let f = 1.0/sectional.denominatorOfFlatteningRatio // Flattening for GRS 80
    let e = sqrt(2*f - f*f) // Eccentricity for GRS 80

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
    let rF:Double = a * F * pow(tF, n) //trying this
    let r:Double = a * F * pow(t, n)
    
    //let rF:Double = a * (1 - pow(e,2)) / pow(1 - pow(e,2)*pow(sin(φ),2),3/2)  //wrong answer on test
    
    let θ:Double = n * (λ - λF)
    let E = EF + r * sin(θ)
    let N = NF + rF - r * cos(θ)

    let (x,y) = UTMToPixel(easting: E, northing: N, sectional: sectional)
    
    return (x:x, y:y)
}
