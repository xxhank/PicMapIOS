//
//  TouristHeadView.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/19.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class TouristHeadView: UIView {

    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var briefView: UILabel!

    @IBOutlet weak var milesView: UILabel!
    @IBOutlet weak var heatView: UILabel!
    @IBOutlet weak var followView: UILabel!
    @IBOutlet weak var fansView: UILabel!

    var viewModel: Tourist_FetchDetail_ViewModel? {
        didSet {
            if let viewModel = viewModel as Tourist_FetchDetail_ViewModel! {
                nameView.text = viewModel.name

                if let url = NSURL(string: viewModel.avatar) {
                    avatarView.hnk_setImageFromURL(url, placeholder: UIImage(named: "avatar"), format: nil, failure: nil, success: nil)
                }

                milesView.text = "\(Int(viewModel.miles)) km"
                heatView.text = "\(viewModel.heat)"
                followView.text = "\(viewModel.follow)"
                fansView.text = "\(viewModel.fans)"
            }
        }
    }
}
