//
//  TouristTripListCell.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/19.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
import TagListView

class TouristTripListCell: UITableViewCell {
    @IBOutlet weak var tripTitleView: UILabel!
    @IBOutlet weak var daysView: UIButton!
    @IBOutlet weak var milesView: UIButton!
    @IBOutlet weak var locationCountView: UIButton!
    @IBOutlet weak var photoCountView: UIButton!
    @IBOutlet weak var photoView: PMIImageView!

    @IBOutlet weak var topPhotosView: TripLocationImageGridView!
    @IBOutlet weak var locationsView: TagListView!

    var viewModel: TripCellViewModel? {
        didSet {
            if let viewModel = viewModel as TripCellViewModel! {
                tripTitleView.text = viewModel.title
                daysView.setTitle("\(viewModel.days)", forState: .Normal)
                milesView.setTitle("\(Int(viewModel.miles))", forState: .Normal)
                locationCountView.setTitle("\(viewModel.locations.count)", forState: .Normal)
                photoCountView.setTitle("\(viewModel.heat)", forState: .Normal)

                locationsView.removeAllTags()
                viewModel.locations.forEach({ (location) -> () in
                    locationsView.addTag(location)
                })
                photoView.imageURL = viewModel.photo
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
