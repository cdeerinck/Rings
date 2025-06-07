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

func loadSectionals(sectionals:Sectionals){
    
    // We can only do this if it isn't already in process
    if sectionals.locked { return }
    sectionals.locked = true
    
    sectionals.sectionals = sortSectionals(sectionals: sectionals.sectionals)
    
        for (index, item) in sectionals.sectionals.enumerated() {
            print(index, item.name)
            sectionals.sectionals[index].status = .error
        }
    
    let url = URL(string: "https://www.faa.gov/air_traffic/flight_info/aeronav/digital_products/vfr")!
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "MM-dd-yyyy"
    
    Task {
        
        // Get html data into string
        do {
            var html = try String(contentsOf: url, encoding: .utf8)
            //print(html, html.count)
            let _ = extractBetweenTokens(content: &html, startToken: "Sectional Aeronautical Raster Charts", endToken: "GEO-TIFF")
            // First we have to sort in the order they appear on the FAA web page
            // Thank you to the FAA wizards for making this strange sort sequence required.
            // They put St Louis before Salt Lake, and so must we.
            for (index, sectional) in sectionals.sectionals.sorted(by: {$0.name.replacingOccurrences(of: "St ", with:"Saint ") < $1.name.replacingOccurrences(of: "St ", with:"Saint ")}).enumerated() {
                //print("-----------------------------------------------------------------------------------------------------------")
                //print(html, html.count)
                let _ = extractBetweenTokens(content: &html, startToken: "<td>"+sectional.name, endToken: "/td>") // Get to the correct entry
                let currentURL = extractBetweenTokens(content: &html, startToken: "<a href=", endToken: ">GEO-T") // Get the current edition
                let _ = extractBetweenTokens(content: &html, startToken: "<a href=", endToken: ">PDF<") // Skip past the PDF
                let nextURL = extractBetweenTokens(content: &html, startToken: "<a href=", endToken: ">GEO-T") // Get the next edition
                //print(currentURL, nextURL)
                var temp:String = currentURL!
                let currentDate = extractBetweenTokens(content: &temp, startToken: "/visual/", endToken: "/sectional")
                if currentDate != nil {
                    sectionals.sectionals[index].currentEdition = dateFormatter.date(from:currentDate!)!
                }
                temp = nextURL!
                let nextDate = extractBetweenTokens(content: &temp, startToken: "/visual/", endToken: "/sectional")
                if nextDate != nil {
                    sectionals.sectionals[index].nextEdition = dateFormatter.date(from:nextDate!)!
                }
                // 1) Delete the cached files for this sectional whose date is before today
                // 2) If no tfw exists, make this sectiona as .unloaded
                if !FileManager.default.fileExists(atPath: "\(FileManager.default.currentDirectoryPath)/\(sectional.name).tfw") {
                    // Mark it as unloaded
                    sectionals.sectionals[index].status = SectionalStatus.unloaded
                } else {
                    // Mark it as loaded
                    sectionals.sectionals[index].status = SectionalStatus.loaded
                }
                // 3) If the sectonal has .keepCurrent || .use load it
                if sectional.keepCurrent || sectional.use {
                    sectionals.sectionals[index].status = SectionalStatus.loading
                    //Load the zip and unzip the files
                }
            }
            
            // Now that everything is done, unlock (which tells the UI to update)
            Task.detached { @MainActor in
                sectionals.locked = false
            }
        
    }
    catch {
        print("Failed to load URL")
        return
    }
}
}


