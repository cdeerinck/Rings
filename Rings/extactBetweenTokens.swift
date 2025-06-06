//
//  extactBetweenTokens.swift
//  SectionalRings
//
//  Created by Chuck Deerinck on 6/5/25.
//

import Foundation

func extractBetweenTokens(content: inout String, startToken: String, endToken: String) -> String? {
    // First find the start token
    
    if content == "" {
        return nil
    }
    
    guard let startRange = content.range(of: startToken) else {
        content = ""
        return nil  // Start token not found, return original content as remainder
    }
    
    // Get the content after the start token
    let afterStart = content[startRange.upperBound...]
    
    // Find the end token in the remaining content
    guard let endRange = afterStart.range(of: endToken) else {
        content = String(afterStart)
        return nil  // End token not found, return all content after start token
    }
    
    // Extract the content between tokens
    let extracted = String(afterStart[..<endRange.lowerBound])
    
    // Get the remainder after the end token
    content = String(afterStart[endRange.upperBound...])
    
    return extracted
}


