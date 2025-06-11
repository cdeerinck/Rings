//
//  loadSectionalDates.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 6/5/25.
//

import Foundation
import UIKit
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
    print("Locked.  Loading...")
    
    sectionals.sortSectionals()
    
    for (index, _) in sectionals.sectionals.enumerated() {
        //print(index, item.name)
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
            for (index, sectional) in sectionals.sectionals.sorted(by: {
                $0.name.replacingOccurrences(of: "St ", with:"Saint ") < $1.name.replacingOccurrences(of: "St ", with:"Saint ")
            }).enumerated() { print("51 async Step \(index) started for \(sectional.name) or \(sectionals.sectionals[index].name)")
                var tempStatus = sectional.status // Update this on the thread, if you change the sectional.status on the main thread.
                                                  // and use this value only when checking.
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
                    Task.detached {
                        @MainActor in sectionals.sectionals[index].currentEdition = dateFormatter.date(from:currentDate!)!
                        //print(sectionals.sectionals[index].name, sectionals.sectionals[index].currentEdition as Any)
                    }
                }
                temp = nextURL!
                let nextDate = extractBetweenTokens(content: &temp, startToken: "/visual/", endToken: "/sectional")
                if nextDate != nil {
                    Task.detached {
                        @MainActor in sectionals.sectionals[index].nextEdition = dateFormatter.date(from:nextDate!)!
                        //print(sectionals.sectionals[index].name, sectionals.sectionals[index].nextEdition as Any)
                    }
                    
                }
                // 1) Delete the cached files for this sectional whose date is before today
                // 2) If no tfw exists, make this sectional as .unloaded
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(sectional.name) SEC.tfw")
                if sectional.name == "Los Angeles" {
                    print("82 async Here!")
                }
                if !FileManager.default.fileExists(atPath: documentsURL.path) {
                    // Mark it as unloaded
                    print("86 async Missing", documentsURL.path.suffix(50))
                    Task.detached {
                        @MainActor in sectionals.sectionals[index].status = SectionalStatus.unloaded
                        print("89 main ", sectionals.sectionals[index].name.suffix(50), sectionals.sectionals[index].status)
                    }
                    tempStatus = .unloaded

                } else {
                    // Mark it as cached
                    print("95 async found", documentsURL.path.suffix(50))
                    Task.detached {
                        @MainActor in sectionals.sectionals[index].status = SectionalStatus.cached
                        print("98 main ", sectionals.sectionals[index].name.suffix(20), sectionals.sectionals[index].status)
                    }
                    let tifURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(sectional.name) SEC.tif")
                    let imageData = try? Data(contentsOf: tifURL)
                    let image = UIImage(data: imageData!) ?? UIImage(systemName:"map.fill")!
                    sectionals.sectionals[index].image = image
                    tempStatus = .cached
                }
                // 3) If the sectonal has .keepCurrent || .use load it
                if (sectional.keepCurrent || sectional.use) && (tempStatus != .loaded && tempStatus != .cached) {
                    Task.detached {
                        @MainActor in sectionals.sectionals[index].status = SectionalStatus.loading
                        print("110 main", sectionals.sectionals[index].name.suffix(20), sectionals.sectionals[index].status)
                    }
                    tempStatus = .loading
                    //Load the zip and unzip the files
                    do {
                        try await unZipData(currentURL!)
                        Task.detached {
                            //do {
                            @MainActor in sectionals.sectionals[index].status = SectionalStatus.loaded
                            print("119 main", sectionals.sectionals[index].name, sectionals.sectionals[index].status)
                        }
                        let tifURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(sectional.name) SEC.tif")
                        let imageData = try? Data(contentsOf: tifURL)
                        let image = UIImage(data: imageData!)!
                        sectionals.sectionals[index].image = image
                        tempStatus = .loaded
                    }
                    catch {
                        print("128 async error: \(error)")
                    }
                }
            }
            
            // Now that everything is done, unlock (which tells the UI to update)
            Task.detached {
                @MainActor in sectionals.locked = false
                print("136 async? Unlocked.")
            }
            
        }
        catch {
            print("141 main Failed to load main URL")
            return
        }
    }
}


