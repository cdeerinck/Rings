import Foundation

func extractBetweenTokens(content: String, startToken: String, endToken: String) -> (extracted: String?, remainder: String?) {
    // First find the start token
    guard let startRange = content.range(of: startToken) else {
        return (nil, content)  // Start token not found, return original content as remainder
    }
    
    // Get the content after the start token
    let afterStart = content[startRange.upperBound...]
    
    // Find the end token in the remaining content
    guard let endRange = afterStart.range(of: endToken) else {
        return (String(afterStart), nil)  // End token not found, return all content after start token
    }
    
    // Extract the content between tokens
    let extracted = String(afterStart[..<endRange.lowerBound])
    
    // Get the remainder after the end token
    let remainder = String(afterStart[endRange.upperBound...])
    
    return (extracted, remainder)
} 