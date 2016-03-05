//
//  Logger.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/5.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Foundation
import XCGLogger

func PMILogInfo(@autoclosure closure: () -> String?, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
    XCGLogger.info(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

func PMILogWarning(@autoclosure closure: () -> String?, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
    XCGLogger.warning(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

func PMILogError(@autoclosure closure: () -> String?, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
    XCGLogger.error(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}