//
//  TouristLocationsCountryCell.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/20.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class TouristLocationsCountryCell: UICollectionViewCell, SupportViewModel {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityCountLabel: UILabel!

    var viewModel: AnyObject! {
        didSet {
            if let viewModel = viewModel as? CountryElement {
                cityCountLabel.text = "\(viewModel.components.count)"
                nameLabel.text = viewModel.name
            }
        }
    }
}
