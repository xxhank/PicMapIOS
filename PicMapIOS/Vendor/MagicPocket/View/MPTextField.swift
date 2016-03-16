//
//  MPTextField.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/16.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class MPTextField: UITextField {
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }

    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }

    private func newBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += insetsValue.left
        newBounds.origin.y += insetsValue.top
        newBounds.size.height -= insetsValue.top + insetsValue.bottom
        newBounds.size.width -= insetsValue.left + insetsValue.right
        return newBounds
    }
}
