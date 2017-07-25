//
//  DataParse.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 10.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation

class DataParse: NSObject, XMLParserDelegate {
    
    var eName : String!
    var prevName : String!
    var foundCharacters = ""
    var fir = false
    var posts : [Posts] = []
    var post : Posts!
    
    struct Constants {
        
        static let item = "item"
        static let title = "title"
        static let pubDate = "pubDate"
        static let description = "description"
        
    }
    
    func parsingDataStart(_ data: Data) -> [Posts] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return posts
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == Constants.item {
            post = Posts()
        }
        eName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if post != nil {
            switch (elementName) {
            case Constants.title: post.postTitle = foundCharacters
            case Constants.pubDate: post.postDate = foundCharacters
            case Constants.description:
                let result = RegularPostChange().changeText(text: foundCharacters)
                post.postDescrip = result[0]
                post.postImage = result[1]
                posts.append(post)
            default: break
            }
        }
        foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if eName == Constants.title || eName == Constants.pubDate {
            foundCharacters = string
        } else if eName == Constants.description {
            foundCharacters += string
        }
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
         print("failure error: ", parseError)
    }
    
}



