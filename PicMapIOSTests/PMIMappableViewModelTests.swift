//
//  PMIMappableViewModelTests.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/13.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

@testable import PicMapIOS

import XCTest
import Nimble
import ObjectMapper

class PMIMappableViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDiverForPMIMappableViewModel() {
//        class ViewModelA: MappableViewModel {
//            typealias ViewModel = ViewModelA
//
//            var name: String?
//
//            required init?(_ map: Map) {
//            }
//
//            func mapping(map: Map) {
//                name <- map["name"]
//            }
//        }

        let viewModelA = PMIMappableViewModel.viewModelFromDictonary(["name": "wangchao"])
        expect(viewModelA).notTo(beNil())
        // expect(viewModelA?.name).to(equal("wangchao"))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
}
