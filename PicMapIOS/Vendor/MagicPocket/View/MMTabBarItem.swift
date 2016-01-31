//
//  MMTabBarItem.swift
//  Memo
//
//  Created by wangchaojs02 on 15/11/1.
//  Copyright © 2015年 wangchaojs02. All rights reserved.
//

import UIKit

class MMTabBarItem:UITabBarItem{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.image = self.image?.imageWithRenderingMode(.AlwaysOriginal)
        self.selectedImage = self.selectedImage?.imageWithRenderingMode(.AlwaysOriginal)
    }
}

class MMBarButtonItem:UIBarButtonItem{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.image = self.image?.imageWithRenderingMode(.AlwaysOriginal)

    }
}