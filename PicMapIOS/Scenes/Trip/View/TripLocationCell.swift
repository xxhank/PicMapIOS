//
//  TripLocationCell.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/15.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class TripLocationCell: UITableViewCell, SupportViewModel {
    @IBOutlet weak var locationView: UILabel!
    @IBOutlet weak var streetView: UILabel!
    @IBOutlet weak var cityView: MPLabel!
    @IBOutlet weak var distanceView: UILabel!
    @IBOutlet weak var heatView: MPLabel!
    @IBOutlet weak var imagesView: TripLocationImageGridView!

    var viewModel: AnyObject! {
        didSet {
            if let viewModel = viewModel as? TripLocationCellViewModel {
                locationView.text = viewModel.location
                streetView.text = viewModel.street
                cityView.text = viewModel.city
                distanceView.text = viewModel.distance
                heatView.text = "\(viewModel.heat)"
                imagesView.datas = viewModel.photos
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
