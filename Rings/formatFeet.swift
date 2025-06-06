//
//  formatFeet.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 5/3/25.
//

import Foundation

func formatFeet(_ feet: Double) -> String {
   let nf = NumberFormatter()
    nf.numberStyle = .decimal
    return nf.string(from: feet as NSNumber)! + "'"
}
