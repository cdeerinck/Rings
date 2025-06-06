//
//  loadSectionalDates.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 6/5/25.
//

import Foundation
/*
 On this page: https://www.faa.gov/air_traffic/flight_info/aeronav/digital_products/vfr/
 Look for "Sectional Aeronautical Raster Charts"
 Do this for each chart
 Look for <td>SectionalName ending in </td>
 Look for <a href= ending in >GEO-TIFF this is the current edition chart
 Look for </td>
 Look for <a href= ending in >GEO-TIFF this is the next edition chart
 */

func loadSectionalDates(sectionals:Sectionals){
    
    // Thank you to the FAA wizards for making this strange sort sequence required.
    // They put St Louis before Salt Lake, and so must we.
    sectionals.sectionals = sectionals.sectionals.sorted(by: {$0.name.replacingOccurrences(of: "St ", with:"Saint ") < $1.name.replacingOccurrences(of: "St ", with:"Saint ")})
    
    for item in sectionals.sectionals {
        print(item.name)
    }
    
    let url = URL(string: "https://www.faa.gov/air_traffic/flight_info/aeronav/digital_products/vfr")!
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "MM-dd-yyyy"
    var dates:[(Int,Date,Date)] = []
    
    Task {
        var html = try! String(contentsOf: url, encoding: .utf8) //{
        
        let _ = extractBetweenTokens(content: &html, startToken: "Sectional Aeronautical Raster Charts", endToken: "GEO-TIFF")
        for (index, sectional) in sectionals.sectionals.enumerated() {
            let _ = extractBetweenTokens(content: &html, startToken: "<td>"+sectional.name, endToken: "/td>") // Get to the correct entry
            let currentURL = extractBetweenTokens(content: &html, startToken: "<a href=", endToken: ">GEO-T") // Get the current edition
            let _ = extractBetweenTokens(content: &html, startToken: "<a href=", endToken: ">PDF<") // Skip past the PDF
            let nextURL = extractBetweenTokens(content: &html, startToken: "<a href=", endToken: ">GEO-T") // Get the next edition
            
            var temp:String = currentURL!
            let currentDate = extractBetweenTokens(content: &temp, startToken: "/visual/", endToken: "/sectional")
            temp = nextURL!
            let nextDate = extractBetweenTokens(content: &temp, startToken: "/visual/", endToken: "/sectional")
            dates.append(contentsOf: [(index,dateFormatter.date(from:currentDate!)!,dateFormatter.date(from:nextDate!)!)])
        }
        
    }
    
    for date in dates {
        print(dates.count)
        print(date)
        sectionals.sectionals[date.0].currentEdition = date.1
        sectionals.sectionals[date.0].nextEdition = date.2
    }
    
    
    
    
}


