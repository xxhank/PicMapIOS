//
//  TouristFollowsController.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/22.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class TouristFollowsController: PMIViewController {
    @IBOutlet weak var touristListView: UITableView!

    var proxy: MMArrayTableViewProxy!
    func setupTouristListView() {
        proxy = MMArrayTableViewProxy(tableView: self.touristListView, identifier: { (tableView, indexPath) -> String in
            if indexPath.row % 2 == 1 {
                return "TouristFollowsCell-Light"
            } else {
                return "TouristFollowsCell-Dark"
            }
        })
    }
}
