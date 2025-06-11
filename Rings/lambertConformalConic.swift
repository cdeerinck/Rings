//
//  Calcs.swift
//  Sectional Rings
//
//  Created by Chuck Deerinck on 4/9/25.
//
//  Tweaked by Cursor on 6/4/2025
//
//  Original information from https://www.iogp.org/wp-content/uploads/2019/09/373-07-02.pdf on Page 19 (Section 3.1.1.1 Lambert Conic Conformal (2SP)

import Foundation
import SwiftUICore
import UIKit

func lambertConformalConic(lat: Double, lon: Double, sectional:Sectional) -> CGPoint {
    
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
    
    return UTMToPixel(easting: E, northing: N, sectional: sectional)

}
/*
 The reverse formulas to derive the latitude and longitude of a point from its Easting and Northing values are:
 ϕ = π/2 – 2atan{t'[(1 – esinϕ)/(1 + esinϕ)]e/2}
 λ = θ'/n +λF
 where
 r' = ±{(E – EF) 2 + [rF – (N – NF)] 2}0.5
 , taking the sign of n
 t' = (r'/(aF))1/n
 θ' = atan2 [(E – EF) , (rF – (N – NF))]
 and n, F, and rF are derived as for the forward calculation.

 Note that the formula for ϕ requires iteration. First calculate t' and then a trial value for ϕ using
 ϕ = π/2-2atan(t'). Then use the full equation for ϕ substituting the trial value into the right hand side of the
 equation. Thus derive a new value for ϕ. Iterate the process until ϕ does not change significantly. The
 solution should quickly converge, in 3 or 4 iterations.
 
 coordinates (ϕ,λ) are pronounced Phi and Lambda.  Where Phi is latitude and Lambda is longitude
*/
func inverseProject(N: Double, E: Double, sectional:Sectional) -> (lat: Double, lon: Double) {

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
    //let t:Double = tan(Double.pi/4 - φ/2)/pow((1-e*sin(φ))/(1+e*sin(φ)),e/2)
    let t1:Double = tan(Double.pi/4 - φ1/2)/pow((1-e*sin(φ1))/(1+e*sin(φ1)),e/2)
    let t2:Double = tan(Double.pi/4 - φ2/2)/pow((1-e*sin(φ2))/(1+e*sin(φ2)),e/2)
    let tF:Double = tan(Double.pi/4 - φF/2)/pow((1-e*sin(φF))/(1+e*sin(φF)),e/2)
    
    // Still need these
    let n:Double = (log(m1) - log(m2)) / (log(t1) - log(t2))
    let F:Double = m1 / (n * pow(t1, n))
    let rF:Double = a * F * pow(tF, n)

    //r' = ±{(E – EF) 2 + [rF – (N – NF)] 2}0.5 , taking the sign of n
    let rPrime:Double = (N < 0.0 ? -1.0 : 1.0) * pow(E - EF,2) + pow(pow(N - NF,2),0.5)

    //t' = (r'/(aF))1/n
    let tPrime:Double = pow(rPrime / (a * F), 1.0 / n)
    //theta' = atan2 [(E- EF),(rF - (N- NF))]
    let θprime = atan2(E - EF, rF - (N - NF))

    let λ = θprime / n + λF
    var ϕ = Double.pi / 2.0 - 2.0 * atan(tPrime)
   
    for _ in stride(from: 1, to: 4, by: 1) {
        ϕ = Double.pi / 2.0 - 2.0 * atan(tPrime  * pow((1 - e*sin(ϕ))/(1+e*sin(ϕ)),e / 2))
    }
    
    return (lat: ϕ, lon: λ)
}

