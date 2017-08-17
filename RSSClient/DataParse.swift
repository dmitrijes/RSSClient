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
    var arrayNews : [News] = []
    var singleNews : News!
    
    struct Constants {
        
        static let item = "item"
        static let title = "title"
        static let pubDate = "pubDate"
        static let description = "description"
        
    }
    
    func parsingDataStart(_ data: Data) -> [News] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return arrayNews
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == Constants.item {
            singleNews = News(context: CoreDataManager.instance.managedObjectPrivateContext)
        }
        eName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if singleNews != nil {
            switch (elementName) {
            case Constants.title: singleNews.title = foundCharacters
            case Constants.pubDate: singleNews.date = DateFormat().convertStringToDate(date: foundCharacters)
            case Constants.description:
                let result = RegularPostChange().changeText(text: foundCharacters)
                singleNews.descrip = result[0]
                singleNews.imageUrl = result[1]
                arrayNews.append(singleNews)
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



