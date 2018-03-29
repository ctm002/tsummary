//
//  Extends.swift
//  tsummary
//
//  Created by OTRO on 30-01-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import Foundation
import SearchTextField

public class SearchTextFieldItemExt : SearchTextFieldItem
{
    public var Id : Int32!
    
    init(title: String, subtitle: String?, id: Int32) {
        super.init(title: title, subtitle: subtitle)
        self.Id = id
    }
}

extension Bundle {
    public var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    public var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

internal extension DateComponents {
    mutating func to12am() {
        self.hour = 0
        self.minute = 0
        self.second = 0
    }
    
    mutating func to12pm(){
        self.hour = 23
        self.minute = 59
        self.second = 59
    }
}

/*
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
*/
