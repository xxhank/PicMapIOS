//
//  TouristLocationsLocationCell.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/20.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class TouristLocationsLocationCell: UITableViewCell, SupportViewModel {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!

    var viewModel: AnyObject! {
        didSet {
            if let viewModel = viewModel as? LocationElement {
                locationLabel.text = viewModel["name"] as? String
                streetLabel.text = viewModel["street"] as? String
            }
        }
    }
}
