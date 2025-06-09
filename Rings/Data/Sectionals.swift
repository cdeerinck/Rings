//
//  Sectionals.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 6/3/25.
//

import Foundation

//List of sectionals on this page: https://www.faa.gov/air_traffic/flight_info/aeronav/digital_products/vfr/
//Need to scan the page looking for the sectionals the their dates

//https://aeronav.faa.gov/visual/04-17-2025/sectional-files/Los_Angeles.zip
//https://aeronav.faa.gov/visual/04-17-2025/sectional-files/Anchorage.zip
//https://aeronav.faa.gov/visual/06-12-2025/sectional-files/San_Francisco.zip

class Sectionals: ObservableObject {
    var faaBaseUrl: String = "https://aeronav.faa.gov/visual/_edition_/sectional-files/"
    var faaBaseExt: String = ".zip"
    @Published var sectionals:[Sectional] = []
    @Published var locked: Bool = false
    
    init() {
        self.sectionals = defaultSectionals()
        for item in self.sectionals.enumerated() {
            if item.element.name == "Los Angeles" {
                sectionals[item.offset].favorite = true
            }
        }
    }
    
    func describe() async {
        for each in self.sectionals {
            print(each.description())
        }
    }
    
    func sortSectionals() {
        self.sectionals = sectionals.sorted(by: { lhs, rhs in
            if lhs.inAK != rhs.inAK {
                return (lhs.inAK ? "Z":"A") < (rhs.inAK ? "Z":"A") // Alaska secitonals go to the end, not a lot of Soaring there.
            } else if lhs.favorite != rhs.favorite {
                return (lhs.favorite ? "A":"Z") < (rhs.favorite ? "A":"Z") // Favorites go first
            } else {
                return lhs.name < rhs.name
            }
        }
        )
    }
}

func defaultSectionals() -> [Sectional] {
    var sectionals:[Sectional] = []
    
    sectionals.append(Sectional(name: "Albuquerque"))
    sectionals.append(Sectional(name: "Anchorage", inAK: true))
    sectionals.append(Sectional(name: "Atlanta"))
    sectionals.append(Sectional(name: "Bethel", inAK: true))
    sectionals.append(Sectional(name: "Billings"))
    sectionals.append(Sectional(name: "Brownsville"))
    sectionals.append(Sectional(name: "Cape Lisburne", inAK: true))
    sectionals.append(Sectional(name: "Charlotte"))
    sectionals.append(Sectional(name: "Cheyenne"))
    sectionals.append(Sectional(name: "Chicago"))
    sectionals.append(Sectional(name: "Cincinnati"))
    sectionals.append(Sectional(name: "Cold Bay", inAK: true))
    sectionals.append(Sectional(name: "Dallas-Ft Worth"))
    sectionals.append(Sectional(name: "Dawson", inAK: true))
    sectionals.append(Sectional(name: "Denver"))
    sectionals.append(Sectional(name: "Detroit"))
    sectionals.append(Sectional(name: "Dutch Harbor", inAK: true))
    sectionals.append(Sectional(name: "El Paso"))
    sectionals.append(Sectional(name: "Fairbanks", inAK: true))
    sectionals.append(Sectional(name: "Great Falls"))
    sectionals.append(Sectional(name: "Green Bay"))
    sectionals.append(Sectional(name: "Halifax"))
    sectionals.append(Sectional(name: "Hawaiian Islands"))
    sectionals.append(Sectional(name: "Houston"))
    sectionals.append(Sectional(name: "Jacksonville"))
    sectionals.append(Sectional(name: "Juneau", inAK: true))
    sectionals.append(Sectional(name: "Kansas City"))
    sectionals.append(Sectional(name: "Ketchikan", inAK: true))
    sectionals.append(Sectional(name: "Klamath Falls"))
    sectionals.append(Sectional(name: "Kodiak", inAK: true))
    sectionals.append(Sectional(name: "Lake Huron"))
    sectionals.append(Sectional(name: "Las Vegas"))
    sectionals.append(Sectional(name: "Los Angeles"))
    sectionals.append(Sectional(name: "McGrath", inAK: true))
    sectionals.append(Sectional(name: "Memphis"))
    sectionals.append(Sectional(name: "Miami"))
    sectionals.append(Sectional(name: "Montreal"))
    sectionals.append(Sectional(name: "New Orleans"))
    sectionals.append(Sectional(name: "New York"))
    sectionals.append(Sectional(name: "Nome", inAK: true))
    sectionals.append(Sectional(name: "Omaha"))
    sectionals.append(Sectional(name: "Phoenix"))
    sectionals.append(Sectional(name: "Point Barrow", inAK: true))
    sectionals.append(Sectional(name: "St Louis"))
    sectionals.append(Sectional(name: "Salt Lake City"))
    sectionals.append(Sectional(name: "San Antonio"))
    sectionals.append(Sectional(name: "San Francisco"))
    sectionals.append(Sectional(name: "Seattle"))
    sectionals.append(Sectional(name: "Seward", inAK: true))
    sectionals.append(Sectional(name: "Twin Cities"))
    sectionals.append(Sectional(name: "Washington"))
    sectionals.append(Sectional(name: "Western Aleutian Islands", inAK: true))
    sectionals.append(Sectional(name: "Wichita"))
    
    return sectionals
}


