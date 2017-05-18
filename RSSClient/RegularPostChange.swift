//
//  RegularPostChange.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 11.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation

class RegularPostChange {
    
    let textPat = "<[\\w =:'~?.\\-\"/]+>"
    let imgPat = "src([\\w\\W]+?)\\s"
    var result = [String]()
    
    func changeText(text: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: textPat, options: [])
        var copyText = text
        var newPosition = 0
        var imageOrVideoLink = ""
        
        let matches = regex.matches(in: copyText, options: [], range: NSRange(location: 0, length: text.characters.count))
        for match in matches {
            for n in 0..<match.numberOfRanges {
                let r = match.rangeAt(n)
                let start = copyText.index(copyText.startIndex, offsetBy: r.location - newPosition)
                let end = copyText.index(start, offsetBy: r.length)
                let range = start..<end
                if imageOrVideoLink == "" {
                    imageOrVideoLink = getImgLinkFromText(sub: copyText[range])
                }
                copyText.removeSubrange(range)
                newPosition += r.length
            }
        }
        var filtr = ""
        copyText.enumerateLines { (line, true) in
            if !line.isEmpty {
                filtr += line + "\n"
            }
        }
        result.append(filtr)
        result.append(imageOrVideoLink)
        imageOrVideoLink = ""
        return result
    }
    
    func getImgLinkFromText(sub: String) -> String {
        let regex = try! NSRegularExpression(pattern: imgPat, options: [])
        
        let range = regex.rangeOfFirstMatch(in: sub, options: [], range: NSRange(location: 0, length: sub.characters.count))
        if range.length == 0 {
            return ""
        }
        let start = sub.index(sub.startIndex, offsetBy: range.location + 5)
        let end = sub.index(start, offsetBy: range.length - 7)
        let rangeOfLink = start..<end
        
        return sub[rangeOfLink]
    }
}