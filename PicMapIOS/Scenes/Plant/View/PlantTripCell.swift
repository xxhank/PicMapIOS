//
//  PlantTripCell.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/14.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
import TagListView
import Haneke

class PlantTripCell: UITableViewCell, SupportViewModel {
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var avatarView: UIImageView!

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var tripTitleView: UILabel!
    @IBOutlet weak var tripBriefView: UILabel!
    @IBOutlet weak var locationsView: TagListView!

    var viewModel: AnyObject! {
        didSet {
            if let viewModel = viewModel as? TripCellViewModel {
                nameView.text = viewModel.author
                if let url = NSURL(string: viewModel.avatar) {
                    avatarView.hnk_setImageFromURL(url, placeholder: UIImage(named: "avatar"), format: nil, failure: nil, success: nil)
                }

                if let url = NSURL(string: viewModel.photo) {
                    photoView.hnk_setImageFromURL(url, placeholder: UIImage(named: "landscape"), format: nil, failure: nil, success: nil)
                }

                tripTitleView.text = viewModel.title
                tripBriefView.text = viewModel.brief
                locationsView.removeAllTags()
                viewModel.locations.forEach({ (location) -> () in
                    locationsView.addTag(location)
                })
            }
        }
    }
}
