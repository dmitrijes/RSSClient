//
//  Constants.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 18.07.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation

struct Constans {
    
    struct feeds {
        static let macRumosUrl = "http://feeds.macrumors.com/MacRumors-All"
    }
    
    struct id {
        static let segueId = "showDetail"
        static let cellId = "postCell"
    }
    
    struct textPattern {
        static let textPat = "<[\\w =:'~?.\\-\"/]+>"
        static let imgPat = "src([\\w\\W]+?)\\s"
    }
    
    struct directoryName {
        static let dicName = "ImagesForTable"
    }
    
}
