//
//  PMITabBarControllerTests.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/1/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import XCTest
@testable import PicMapIOS

class ExternalViewController: UIViewController{
    
}

class PMITabBarControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoadExternalController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let tabBarController = storyboard.instantiateInitialViewController() as! PMITabBarController;
        tabBarController.view.frame = CGRectZero;
        
        XCTAssertEqual(tabBarController.viewControllers?.count, 3);
    }
    
    func testPerformanceLoadExternalStoryboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
         self.measureBlock {
            storyboard.instantiateInitialViewController();
         }
    }
    
}
