//
//  PMIImageView.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/19.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class PMIImageView: UIImageView {
    override func awakeFromNib() {
        placeholderImage = self.image
        if placeholderImage == nil {
            if let placeholder = self.placeholder {
                placeholderImage = UIImage(named: placeholder)
            }
        }
    }
    var placeholderImage: UIImage?
    @IBInspectable var placeholder: String?
    var imageURL: String? {
        didSet {
            let placeholdImage = self.placeholderImage

            var url : NSURL? = nil
            if let imageURL = self.imageURL {
                url = NSURL(string: imageURL)
            }
            self.image = placeholdImage
            if url != nil {
                self.hnk_setImageFromURL(url!, placeholder: placeholdImage, format: nil, failure: nil, success: nil)
            }
        }
    }
}
