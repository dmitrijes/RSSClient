//
//  DateFormat.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 03.08.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation

class DateFormat {
    
    func getDatePost(date: String) -> String {
        if date != "" {
            let currentDate = Date()
            let dateForm = DateFormatter()
            dateForm.timeZone = TimeZone(abbreviation: "GMT")
            dateForm.dateFormat = "EEE. dd MMM yyyy HH:mm:ss zzz"
            let postDate = dateForm.date(from: date)
            var diff = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: postDate!, to: currentDate)
            if diff.minute! < 60, diff.hour! == 0 {
                return "\(diff.minute!) minutes ago"
            } else if diff.hour! >= 1, diff.hour! <= 24 {
                switch diff.hour! {
                case 1:
                    return "1 hour ago"
                default:
                    return "\(diff.hour!) hours ago"
                }
            } else if diff.hour! >= 24, diff.hour! >= 48 {
                return "Yesterday"
            } else {
                let newDate = Calendar.current.date(from: diff)
                dateForm.dateStyle = .short
                return dateForm.string(from: newDate!)
            }
        }
        return ""
    }

    
}
