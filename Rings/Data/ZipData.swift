//
//  ZipData.swift
//  Rings
//
//  Created by Luke Deerinck on 6/6/25.
//

import Foundation
import ZIPFoundation

func unZipData(_ url:String) async throws {
    //URL.documents
    let fileManager = FileManager()
    let sourceURL = URL(string: url)!
    let zipUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(sourceURL.lastPathComponent)
    let tifUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    do {
        try await downloadSectionalZip(from: sourceURL, to: zipUrl)
        try fileManager.unzipItem(at: zipUrl, to: tifUrl)
        try fileManager.removeItem(at: zipUrl)
        print("unzipped successfully to \(tifUrl)")
    } catch {
        throw error
    }
}



