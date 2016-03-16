//
//  TripEditLocationCell.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/13.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class TripEditLocationCell: UITableViewCell, SupportViewModel {
    @IBOutlet weak var locationView: UILabel!
    @IBOutlet weak var streetView: UILabel!
    @IBOutlet weak var cityView: MPLabel!
    @IBOutlet weak var imagesView: TripLocationImageGridView!

    @IBOutlet weak var introTextField: UITextField!
    @IBOutlet weak var briefTextField: KMPlaceholderTextView!

    override func awakeFromNib() {
        var inset = self.briefTextField.textContainerInset
        inset.left = 10
        inset.right = 10
        self.briefTextField.textContainerInset = inset
    }

    var viewModel: AnyObject! {
        didSet {
            if let viewModel = viewModel as? TripLocationEditCellViewModel {
                locationView.text = viewModel.location
                streetView.text = viewModel.street
                cityView.text = viewModel.city
                imagesView.datas = viewModel.albumPhotos
            }
        }
    }
}
