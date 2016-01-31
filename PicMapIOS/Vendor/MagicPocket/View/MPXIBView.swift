//
//  MPXIBView.swift
//  Memo
//
//  Created by wangchaojs02 on 15/11/15.
//  Copyright © 2015年 wangchaojs02. All rights reserved.
//

import UIKit

class MPXIBView: UIView {
    /// 是否是模板
    @IBInspectable var templete:Bool = false {
        didSet {
            
        }
    }
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        if self.tag != -1{
            return self.dynamicType.realViewFromPlaceholder(self)
        }
        return self;
    }
    
    class func realViewFromPlaceholder(placeholderView:UIView)->AnyObject?{
        let nibName = self.nameOfClass
        let views = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil)
        let realView:UIView = views.first as! UIView
        realView.tag                                       = placeholderView.tag;
        realView.frame                                     = placeholderView.frame;
        realView.bounds                                    = placeholderView.bounds;
        realView.hidden                                    = placeholderView.hidden;
        realView.clipsToBounds                             = placeholderView.clipsToBounds;
        realView.autoresizingMask                          = placeholderView.autoresizingMask;
        realView.userInteractionEnabled                    = placeholderView.userInteractionEnabled;
        realView.translatesAutoresizingMaskIntoConstraints = placeholderView.translatesAutoresizingMaskIntoConstraints;
        
        for constraint in placeholderView.constraints {
            if (nil == constraint.secondItem)
            {
                // Height or width constraint.
                constraint.setValue(realView, forKey: "firstItem")
                realView.addConstraint(constraint)
            }
            else if constraint.firstItem.isEqual(constraint.secondItem)
            {
                // Aspect ratio constraint.
                constraint.setValue(realView, forKey: "firstItem")
                constraint.setValue(realView, forKey: "secondItem")
                realView.addConstraint(constraint)
            }
        }
        return realView;
    }
}
