//
//  TouristLocationsCityCell.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/20.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class TouristLocationsCityCell: UICollectionViewCell, SupportViewModel {

    @IBOutlet weak var nameLabel: MPLabel!

    @IBInspectable var textColor = UIColor(hex: 0xd7e1eb)
    @IBInspectable var selectedTextColor = UIColor(hex: 0x7d8791)
    @IBInspectable var tagColor = UIColor(hex: 0x7d8791)
    @IBInspectable var selectedTagColor = UIColor(hex: 0xd7e1eb)

    var viewModel: AnyObject! {
        didSet {
            if let viewModel = viewModel as? ProvinceElement {
                nameLabel.text = viewModel.name
            }
        }
    }

    override func awakeFromNib() {
        self.nameLabel.textColor = textColor
        self.nameLabel.backgroundColor = tagColor
        self.nameLabel.insets = "15,0"
        self.corners = "15"
    }
    override var selected: Bool {
        didSet {
            if self.selected {
                self.nameLabel.textColor = selectedTextColor
                self.nameLabel.backgroundColor = selectedTagColor
            }
            else {
                self.nameLabel.textColor = textColor
                self.nameLabel.backgroundColor = tagColor
            }
        }
    }
}
