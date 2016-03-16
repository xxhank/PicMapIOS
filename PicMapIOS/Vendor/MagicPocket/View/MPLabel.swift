//
//  MPLabel.swift
//  Memo
//
//  Created by wangchaojs02 on 15/10/28.
//  Copyright © 2015年 wangchaojs02. All rights reserved.
//

import UIKit

class MPLabel : UILabel {
    override func intrinsicContentSize() -> CGSize {
        var size: CGSize = super.intrinsicContentSize() ;
        size.width += insetsValue.left + insetsValue.right;
        size.height += insetsValue.top + insetsValue.bottom;

        return size;
    }

    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insetsValue))
    }
}

extension String {
    func doubleValue() -> Double {
        return (NSNumberFormatter().numberFromString(self)?.doubleValue)!;
    }

    /**
     从字符串生成UIEdgeInsets.支持下面三种语法:
     1:padding
     2:horizontal, vertical
     3:left, top, right, bottom
     */
    func insetsValue() -> UIEdgeInsets {
        let components: [String] = self.componentsSeparatedByString(",") ;
        if components.count == 1 {
            let value = CGFloat(components[0].doubleValue()) ;
            return UIEdgeInsetsMake(value, value, value, value) ;
        }
        else if components.count == 2 {
            let valueHorizontal = CGFloat(components[0].doubleValue()) ;
            let valueVertical = CGFloat(components[1].doubleValue()) ;
            return UIEdgeInsetsMake(valueVertical, valueHorizontal, valueVertical, valueHorizontal) ;
        } else if components.count == 4 {
            let left = CGFloat(components[0].doubleValue()) ;
            let top = CGFloat(components[1].doubleValue()) ;
            let right = CGFloat(components[2].doubleValue()) ;
            let bottom = CGFloat(components[3].doubleValue()) ;
            return UIEdgeInsetsMake(top, left, bottom, right) ;
        } else {

            PMILogWarning("invalid insets string \(self).")
            return UIEdgeInsetsZero;
        }
    }
}