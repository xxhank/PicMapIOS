//
//  CamerPhotosCell.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/5.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class CameraPhotosCell: UICollectionViewCell, SupportViewModel {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var markView: UIImageView!

    var viewModel: AnyObject! {
        didSet {
            if let viewModel = viewModel as? PhotosFromAlbumPhotoViewModel {
                viewModel.loadImage(self.bounds.size, completion: { (image) -> Void in
                    self.photoView.image = image
                })
            }
        }
    }
}
