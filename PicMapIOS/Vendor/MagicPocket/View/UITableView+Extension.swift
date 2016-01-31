//
//  UITableView+Extension.swift
//  Memo
//
//  Created by wangchaojs02 on 15/11/2.
//  Copyright © 2015年 wangchaojs02. All rights reserved.
//

import UIKit

/** Extension Extends UITableView

*/
extension UITableView {
    func registerNibName(nibName:String, forCellReuseIdentifier identifier:String ){
        let nib = UINib(nibName: nibName, bundle: nil) as UINib
        self.registerNib(nib, forCellReuseIdentifier: identifier)
    }
}


extension UICollectionView{
    func registerNibName(nibName:String, forCellReuseIdentifier identifier:String ){
        let nib = UINib(nibName: nibName, bundle: nil) as UINib
        self.registerNib(nib, forCellWithReuseIdentifier: identifier)
    }
}