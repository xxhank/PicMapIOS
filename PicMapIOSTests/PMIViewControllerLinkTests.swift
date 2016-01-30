//
//  PMIViewControllerLinkTests.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/1/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import XCTest
@testable import PicMapIOS

class PMIViewControllerLinkTests: PMITestCase {
    var link:PMIViewControllerLink?;

    override func setUp() {
        super.setUp()
        link = PMIViewControllerLink();
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    // MARK: - Instantiate Form Storyboard

    func testLinkToStoryboard() {
        link!.externalResource = "sb://Test";
        let (controller, error, storyboard) = link!.externalResource.pmi_controller(NSBundle(forClass: self.dynamicType))
        XCTAssertNotNil(controller)
        XCTAssertEqual(controller?.isKindOfClass(UINavigationController), true)
        XCTAssertNotNil(storyboard)
        XCTAssertNil(error)
    }
    
    func testLinkToControllerInStoryboard(){
        link!.externalResource = "sb://Test/UITableViewController";
        
        let (controller, error, storyboard) = link!.externalResource.pmi_controller(NSBundle(forClass: self.dynamicType))
        XCTAssertNotNil(controller)
        XCTAssertEqual(controller?.isKindOfClass(UITableViewController), true)
        XCTAssertNotNil(storyboard)
        XCTAssertNil(error)
    }
    
    
    func testNotExistStoryboard(){
        link!.externalResource = "sb://SomeStoryboard";
        
        let (controller, error, storyboard) = link!.externalResource.pmi_controller(NSBundle(forClass: self.dynamicType))
        XCTAssertNil(controller)
        XCTAssertNil(storyboard)
        XCTAssertEqual(error?.code, PMIViewControllerLinkError.CannotLoadStoryboard.rawValue)
    }
    
    
    func testControllerNotExistInStoryboard(){
        link!.externalResource = "sb://Test/NotExistController";
        let (controller, error, storyboard) = link!.externalResource.pmi_controller(NSBundle(forClass: self.dynamicType))
        XCTAssertNil(controller)
        XCTAssertNotNil(storyboard)
        XCTAssertEqual(error?.code, PMIViewControllerLinkError.CannotInstantiateViewController.rawValue)
    }
    
    // MARK: - Instantiate Controller From Nib
    func testLinkToANibFile(){
        link!.externalResource = "xib://TestViewController";
        let (controller, error, _) = link!.externalResource.pmi_controller(self.bundle, module: self.module)
        XCTAssertNotNil(controller)
        XCTAssertTrue(controller?.isKindOfClass(TestViewController) == true)
        XCTAssertNil(error)
    }
    
    // MARK: - Instantiate Controller From Code
    func testLinkToCode(){
        link!.externalResource = "code://TestViewControllerNoNib";
        let (controller, error, _) = link!.externalResource.pmi_controller(self.bundle, module: self.module)
        XCTAssertNotNil(controller)
        XCTAssertTrue(controller?.isKindOfClass(TestViewControllerNoNib) == true)
        XCTAssertNil(error)
    }
    
    func testLinkToEmpty(){
        link!.externalResource = "";
        
        let (storyboard, controller) = link!.externalResource.pmi_storyboard();
        XCTAssertNil(storyboard);
        XCTAssertNil(controller);
        
        let (xibName,controllerName) = link!.externalResource.pmi_nibName();
        XCTAssertNil(xibName);
        XCTAssertNil(controllerName)
        
        let className = link!.externalResource.pmi_className();
        XCTAssertNil(className);
    }
    
    func testInvaidLink(){
        link!.externalResource = "sb://";
        
        let (storyboard, controller) = link!.externalResource.pmi_storyboard();
        XCTAssertNil(storyboard);
        XCTAssertNil(controller);
    
        link!.externalResource = "xib://";
        let (xibName, controllerName) = link!.externalResource.pmi_nibName();
        XCTAssertNil(xibName);
        XCTAssertNil(controllerName)

        link!.externalResource = "code://";
        let className = link!.externalResource.pmi_className();
        XCTAssertNil(className);
    }
    
    func testInvaidLinkWithSuffixSlash(){
        link!.externalResource = "sb://SomeStoryboard/SomeController/";
        
        let (storyboard, controller) = link!.externalResource.pmi_storyboard();
        XCTAssertNil(storyboard);
        XCTAssertNil(controller);
        
        link!.externalResource = "xib://SomeNibFile/SomeClass/";
        let (xibName, controllerName) = link!.externalResource.pmi_nibName();
        XCTAssertNil(xibName);
        XCTAssertNil(controllerName)

        link!.externalResource = "code://SomeClass/";
        let className = link!.externalResource.pmi_className();
        XCTAssertNil(className);
    }
    
    func testPerformanceForParse() {
        self.measureBlock {
            let link = PMIViewControllerLink();
            link.externalResource = "sb://SomeStoryboard/SomeController"
            let (_, _) = link.externalResource.pmi_storyboard();
            
            link.externalResource = "xib://SomeNibFile";
            let _ = link.externalResource.pmi_nibName();
            
            link.externalResource = "code://SomeClass";
            let _ = link.externalResource.pmi_className();
        }
    }
    
}
