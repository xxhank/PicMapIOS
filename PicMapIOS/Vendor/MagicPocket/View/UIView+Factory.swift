//
//  UIView+Factory.swift
//  Memo
//
//  Created by wangchaojs02 on 15/11/1.
//  Copyright © 2015年 wangchaojs02. All rights reserved.
//

import UIKit

/**
 * Factory Extends UIView
 */

extension UIView {
    class func viewFromXib()->UIView {
        return  self.viewFromXib(self.nameOfClass)
    }

    class func viewFromXib(xibName:String)->UIView {
        return NSBundle.mainBundle().loadNibNamed(xibName, owner: nil, options: nil)[0] as! UIView
    }
}
