//
//  DowloadSectionalZip.swift
//  Rings
//
//  Created by Luke Deerinck on 6/6/25.
//

import Foundation

// example of a button that downloads a zip file and unzips it:
//Button {
//    Task {
//        do {
//            try await unZipData("https://aeronav.faa.gov/visual/04-17-2025/sectional-files/Los_Angeles.zip")
//        }
//        catch {
//            print(error.localizedDescription)
//        }
//    }
//} label: {
//    Text("UnZip ")
//}

func downloadSectionalZip(from url: URL, to destinationURL: URL) async throws {
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }
    
    try data.write(to: destinationURL, options: .atomic)
}
