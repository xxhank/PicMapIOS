//
//  NSObject+ClassName.swift
//  Memo
//
//  Created by wangchaojs02 on 15/11/1.
//  Copyright © 2015年 wangchaojs02. All rights reserved.
//

import Foundation

/** 
 * ClassName Extends NSObject
 */
public extension NSObject{
    public class var nameOfClass: String{
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }

    public var nameOfClass: String{
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
}