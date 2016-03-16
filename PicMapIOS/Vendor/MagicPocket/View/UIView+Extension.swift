//
//  UIView+Extension.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/16.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

extension UIView {
    private struct AssociatedKeys {
        static var InsetsValueName = "insetsValue"
        static var CornerValueName = "cornersValue"
    }

    @IBInspectable var corners: String {
        get {
            return "\(cornersValue.left),\(cornersValue.top),\(cornersValue.right),\(cornersValue.bottom)"
        }
        set {
            cornersValue = newValue.insetsValue() ;
        }
    }

    var cornersValue: UIEdgeInsets {
        get {
            if let number = objc_getAssociatedObject(self, &AssociatedKeys.CornerValueName) as? NSValue {
                return number.UIEdgeInsetsValue() ;
            } else {
                return UIEdgeInsetsZero;
            }
        }
        set {
            let number = NSValue(UIEdgeInsets: newValue) ;
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.CornerValueName,
                number,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )

            self.layer.cornerRadius = newValue.left;
        }
    }

    @IBInspectable var insets: String {
        get {
            return "\(insetsValue.left),\(insetsValue.top),\(insetsValue.right),\(insetsValue.bottom)"
        }
        set {
            insetsValue = newValue.insetsValue() ;
        }
    }
    var insetsValue: UIEdgeInsets {
        get {
            if let number = objc_getAssociatedObject(self, &AssociatedKeys.InsetsValueName) as? NSValue {
                return number.UIEdgeInsetsValue() ;
            } else {
                return UIEdgeInsetsZero;
            }
        }
        set {
            let number = NSValue(UIEdgeInsets: newValue) ;
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.InsetsValueName,
                number,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
