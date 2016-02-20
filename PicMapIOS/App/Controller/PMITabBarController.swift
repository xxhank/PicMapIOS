//
//  PMITabBarController.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/1/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
import SwiftHEXColors
class PMITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBarIcons() ;
        self.setupControllers() ;
    }

    func setupControllers() {
        let controllers = self.viewControllers as! [PMIViewControllerLink] ;
        var realControllers : [UIViewController] = [] ;
        for controller in controllers {
            let (externalController, _, _) = controller.externalResource.pmi_controller() ;
            if let realController = externalController {
                realController.tabBarItem = controller.tabBarItem;
                realControllers.append(realController) ;
            }
        }

        self.viewControllers = realControllers;
    }

    func setupTabBarIcon(item: UITabBarItem) {
        item.image = item.image?.imageWithRenderingMode(.AlwaysOriginal) ;
        item.selectedImage = item.selectedImage?.imageWithRenderingMode(.AlwaysOriginal)
        item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
    }
    func setupTabBarIcons() {
        self.tabBar.barTintColor = UIColor(hex: 0x414b55) ;
        let items: [UITabBarItem] = self.tabBar.items!;
        for item in items {
            setupTabBarIcon(item)
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
