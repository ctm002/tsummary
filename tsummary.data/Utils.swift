//
//  Utils.swift
//  tsummary
//
//  Created by OTRO on 18-01-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import Foundation

public class Utils
{
    static func toDateFromString(_ string: String) -> Date?
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_CL")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: string)
    }
    
    static func toStringFromDate(_ date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_CL")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}
