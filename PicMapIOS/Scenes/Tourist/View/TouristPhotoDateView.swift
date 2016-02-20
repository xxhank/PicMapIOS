//
//  TouristPhotoDateView.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/20.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class TouristPhotoDateView: UICollectionReusableView, SupportViewModel {
    @IBOutlet weak var dateLabel: UILabel!
    var viewModel: AnyObject! = "" {
        didSet {
            dateLabel.text = viewModel as? String
        }
    }
}
