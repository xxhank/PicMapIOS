//
//  CamerPhotosSectionHeaderView.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/5.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class CameraPhotosSectionHeaderView: UICollectionReusableView, SupportViewModel {
    
    @IBOutlet weak var locationView: UILabel!
    @IBOutlet weak var streetView: UILabel!
    @IBOutlet weak var cityView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    
    var viewModel: AnyObject! {
        didSet {
            if let viewModel = viewModel as? PhotosFromAlbumSectionViewModel {
                locationView.text = viewModel.location
                streetView.text = viewModel.street
                cityView.text = viewModel.city
                dateView.text = viewModel.date
            }
        }
    }
}
