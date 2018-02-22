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
