//
//  PMITestCase.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/1/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import XCTest

class PMITestCase:XCTestCase{
    var bundle:NSBundle{
        get{
            return NSBundle(forClass: self.dynamicType)
        }
    }
    
    var module:String {
        get{
            return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").first!
        }
    }
}