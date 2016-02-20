//
//  TouristLocationsCityCell.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/20.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class TouristLocationsCityCell: UICollectionViewCell, SupportViewModel {

    @IBOutlet weak var nameLabel: UILabel!

    var viewModel: AnyObject! {
        didSet {
            if let viewModel = viewModel as? ProvinceElement {
                nameLabel.text = viewModel.name
            }
        }
    }
}
