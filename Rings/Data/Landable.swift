//
//  Landable.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 6/5/25.
//

import Foundation

class Landable: ObservableObject, Hashable, Identifiable, Copyable, Escapable {
    var id:UUID = UUID()
    var icao:String
    var name:String
    var sectional:String
    var lat:Double
    var lon:Double
    var elev:Int
    var length:Int
    var width:Int
    //    var tiffX:Double
    //    var tiffY:Double
    var pixelX:Double
    var pixelY:Double
    var location:CGPoint {
        get { return CGPoint(x:pixelX, y:pixelY) }
        set {
            pixelX = newValue.x
            pixelY = newValue.y
        }
    }
    //    var pdfX:Double
    //    var pdfY:Double
    var note:String
    //    var errX:Double
    //    var errY:Double
    var useable:Bool
    
    init(_ icao: String, _ name: String, _ sectional: String, _ lat: Double, _ lon: Double, _ elev: Int, _ length: Int, _ width: Int, /* _ tiffX: Double, _ tiffY: Double, _ pdfX: Double, _ pdfY: Double, _ note: String, _ errX: Double, _ errY: Double,*/ _ pixelX:Double, _ pixelY:Double, _ note:String, _ useable:Bool = true) {
        self.icao = icao
        self.name = name
        self.sectional = sectional
        self.lat = lat
        self.lon = lon
        self.elev = elev
        self.length = length
        self.width = width
        //        self.tiffX = tiffX
        //        self.tiffY = tiffY
        //        self.pixelX = self.tiffX / 55.54 * 16645.0
        //        self.pixelY = self.tiffY / 41.35 * 12349.0
        self.pixelX = pixelX
        self.pixelY = pixelY
        //        self.pdfX = pdfX
        //        self.pdfY = pdfY
        self.note = note
        //        self.errX = errX
        //        self.errY = errY
        self.useable = useable
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func ==(lhs: Landable, rhs: Landable) -> Bool {
        return lhs.name == rhs.name
    }
    
    func description() -> String {
        return "Landable(\"\(self.icao)\",\"\(self.name)\",\"\(self.sectional)\",\(self.lat),\(self.lon),\(self.elev),\(self.length),\(self.width),\(self.pixelX),\(self.pixelY),\"\(self.note)\")"
    }
}

