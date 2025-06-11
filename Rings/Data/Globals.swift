//
//  RingColors.swift    <- rename this to Globals
//  Sectional Rings
//
//  Created by Chuck Deerinck on 4/25/25.
//

import Foundation
import SwiftUI

class Globals: ObservableObject {
    //green, green2yellow, yellow, yellow2red, 3 colors, 2 gradients
    @Published var colors: [Color] = [Color.green.opacity(0.2), Color.yellow.opacity(0.2), Color.red.opacity(0.2)]// Must be 3 of these
    @Published var safety: [Int] = [100, 50, 40, 30, 20, 10] { // Must be 6 of these each between 100 and 0.
            didSet {
                let changedIndex = zip(safety, oldValue).map{$0 != $1}.enumerated().filter{$1}.map{$0.0}.first
                if changedIndex == nil { return } // If nothing changed, leave
                if changedIndex == 0 {
                    if safety[0] != 100 { safety[0] = 100 } // This one cannot change, must be 100%
                    return
                }
                if safety[changedIndex!] < oldValue[changedIndex!] { // Tried to make it smaller
                    if safety[changedIndex!] < 5 - changedIndex! {
                        safety[changedIndex!] = 5 - changedIndex!
                        return
                    }
                    if changedIndex! < 5 {
                        if safety[changedIndex!] - safety[changedIndex!+1] < 1 {
                            safety[changedIndex!+1] = safety[changedIndex!] - 1
                        }
                    }
                }
                if safety[changedIndex!] > oldValue[changedIndex!] { // Tried to make it bigger
                    if safety[changedIndex!] >= 101 - changedIndex! {
                        safety[changedIndex!] = 101 - changedIndex!
                        return
                    }
                    if changedIndex! > 0 {
                        if safety[changedIndex!-1] - safety[changedIndex!] < 1  {
                            safety[changedIndex!-1] = safety[changedIndex!] + 1
                        }
                    }
                }
            }
        }
    // that means we are green from 0% to 50%, green/yellow gradient from 50% to 70%, yellow from 70% to 80%, yellow/red from 80% to 90%, and red from 90% to 100%
    // rings 0, 2, 4 are solid, and rings 1 and 3 are gradients.
    @Published var lOverD:Double = 23.0 //51.5
    @Published var patternAltitude:Double = 1000.0
    @Published var pixelsPerNM:Double = 43.5 // True for LA Sectional at least
    @Published var elevation:Double = 10000.0
    @Published var useGradients = false
    var sectionalInUse:Sectional?
}

//var globalSettings = Globals()

var nfFeet: NumberFormatter = {
    let nfFeet = NumberFormatter()
    nfFeet.numberStyle = .decimal
    return nfFeet
}()

func displayInfo(ring:Globals) -> String {
    var str = "L/D : \(Double(Int(10.0 * ring.lOverD)) / 10):1\n"
    str += "Pattern Altitude: \(formatFeet(ring.patternAltitude))\n"
    str += "Elevation: \(formatFeet(ring.elevation))\n"
    str += "Safety % : >=\(ring.safety[1])%, \(ring.safety[2])%-\(ring.safety[3])%, \(ring.safety[4])%-\(ring.safety[5])%"
    return str
}

func fileName(ring:Globals) -> String {
    let str = "Los_Angeles SEC \(Double(Int(10.0 * ring.lOverD)) / 10):1 \(Int(ring.elevation))"
    return str
}
