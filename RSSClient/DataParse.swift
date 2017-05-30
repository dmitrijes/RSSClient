//
//  DataParse.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 10.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation

class DataParse: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var eName = ""
    var prevName = ""
    var fir = false
    var posts : [Posts] = []
    var post : Posts!
    var foundCharacters = ""
    var regular = RegularPostChange()
    var result : [String]!
    
    func parsingDataStart(_ data: Data, complition: ([Posts]?, URLResponse?, Error?) -> Void) {
        parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        complition(posts, nil, nil)
        return
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            post = Posts()
        }
        eName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if post != nil {
            switch (elementName) {
            case "title": post.postTitle = foundCharacters
            case "pubDate": post.postDate = foundCharacters
            case "description":
                result = regular.changeText(text: foundCharacters)
                post.postDescrip = result[0]
                post.postImage = result[1]
                posts.append(post)
            //case "channel":
                
            default: break
            }
        }
        foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if eName == "title" || eName == "pubDate" {
            foundCharacters = string
        } else if eName == "description" {
            foundCharacters += string
        }
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
         print("failure error: ", parseError)
    }
}



