//
//  TouristPhotoListCell.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/20.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class TouristPhotoListCell: UICollectionViewCell, SupportViewModel {
    @IBOutlet weak var photoView: PMIImageView!
    var viewModel: AnyObject! {
        didSet {
            if let viewModel = viewModel as? PhotoViewModel {
                photoView.imageURL = viewModel.url
            }
        }
    }
}
