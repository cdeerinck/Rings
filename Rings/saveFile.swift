//
//  saveFile.swift
//  SectionalRings
//
//  Created by Luke Deerinck on 5/1/25.
//

import Foundation
import SwiftUI

func saveFile(image: UIImage, suffix: String = ""){
    
    //save file
    if let data = image.pngData() {
        let str = fileName(ring: Globals())+suffix+".png"
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(str)
        print(filename)
        try? data.write(to: filename)
    }
}
