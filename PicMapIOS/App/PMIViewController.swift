//
//  PMIViewController.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/16.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class PMIViewController: UIViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    // MARK: - IBAction
    @IBAction func popViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
