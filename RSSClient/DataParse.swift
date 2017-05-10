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
    
    func parsingDataStart(_ data: Data) {
        parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        eName = elementName
        if elementName == "item" {
            post = Posts()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (post != nil) {
            if eName == "title" {
                post.postTitle = foundCharacters
            } else if eName == "pubDate" {
                post.postDate = foundCharacters
            } else if eName == "description" {
                post.postDescrip = foundCharacters
                print(foundCharacters)
                print("---------")
            }
            
            if post.postTitle != nil && post.postDate != nil && post.postDescrip != nil {
                posts.append(post)
                post = nil
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if eName == "title" || eName == "pubDate" {
            foundCharacters = string
        } else if eName == "description" && post != nil {
            print(string)
            foundCharacters += string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
         print("failure error: ", parseError)
    }
}
