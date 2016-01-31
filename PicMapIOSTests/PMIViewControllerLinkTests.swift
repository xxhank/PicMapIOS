//
//  PMIViewControllerLinkTests.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/1/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

@testable import PicMapIOS
import XCTest
import Quick
import Nimble

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
    
    func testLinkToANibFileWithClassName(){
        link!.externalResource = "xib://TestViewController/TestViewController";
        let (controller, error, _) = link!.externalResource.pmi_controller(self.bundle, module: self.module)
        XCTAssertNotNil(controller)
        XCTAssertTrue(controller?.isKindOfClass(TestViewController) == true)
        XCTAssertNil(error)
    }
    
    func testLinkToANibFileWithNotExistClass(){
        link!.externalResource = "xib://TestViewController/TestViewController1";
        let (controller, error, _) = link!.externalResource.pmi_controller(self.bundle, module: self.module)
        XCTAssertNil(controller)
        expect(error?.code).to(equal(PMIViewControllerLinkError.CannotInstantiateViewController.rawValue))
    }
    
    // MARK: - Instantiate Controller From Code
    func testLinkToCode(){
        link!.externalResource = "code://TestViewControllerNoNib";
        let (controller, error, _) = link!.externalResource.pmi_controller(self.bundle, module: self.module)
        XCTAssertNotNil(controller)
        XCTAssertTrue(controller?.isKindOfClass(TestViewControllerNoNib) == true)
        XCTAssertNil(error)
    }
    
    func testLinkToCodeNotExistClass(){
        link!.externalResource = "code://NotExistClass";
        let (controller, error, _) = link!.externalResource.pmi_controller(self.bundle, module: self.module)
        XCTAssertNil(controller)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.code, PMIViewControllerLinkError.CannotCreateClass.rawValue)
    }
    
    func testLinkToEmpty(){
        link!.externalResource = "";
        
        var (controller, error, storyboard) = link!.externalResource.pmi_controller(self.bundle, module: self.module);
        XCTAssertNil(storyboard);
        XCTAssertNil(controller);
        
        (controller, error, storyboard) = link!.externalResource.pmi_controller(self.bundle, module: self.module);
        XCTAssertNil(controller);
        
        (controller, error, storyboard) = link!.externalResource.pmi_controller(self.bundle, module: self.module);
        XCTAssertNil(controller);
    }
    
    func testInvaidLink(){
        link!.externalResource = "sb://";
        
        var (controller, error, storyboard) = link!.externalResource.pmi_controller(self.bundle, module: self.module);
        XCTAssertNil(storyboard);
        XCTAssertNil(controller);
    
        link!.externalResource = "xib://";
        (controller, error, _) = link!.externalResource.pmi_controller(self.bundle, module: self.module);
        XCTAssertNil(controller);
        expect(error?.code).to(equal(PMIViewControllerLinkError.IncompleteLink.rawValue))
        
        link!.externalResource = "code://";
        (controller, error, _) = link!.externalResource.pmi_controller(self.bundle, module: self.module);
        expect(controller).to(beNil())
        
        link!.externalResource = "not-support-prefix://";
        (controller, error, _) = link!.externalResource.pmi_controller(self.bundle, module: self.module);
        expect(controller).to(beNil())
    }
    
    func testInvaidLinkWithSuffixSlash(){
        link!.externalResource = "sb://SomeStoryboard/SomeController/";
        
        var (controller, _, storyboard) = link!.externalResource.pmi_controller(self.bundle, module: self.module);
        XCTAssertNil(storyboard);
        XCTAssertNil(controller);
        
        link!.externalResource = "xib://SomeNibFile/SomeClass/";
        (controller, _, _) = link!.externalResource.pmi_controller(self.bundle, module: self.module);
        XCTAssertNil(controller);

        link!.externalResource = "code://SomeClass/";
        (controller, _, _) = link!.externalResource.pmi_controller(self.bundle, module: self.module);
        XCTAssertNil(controller);
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
