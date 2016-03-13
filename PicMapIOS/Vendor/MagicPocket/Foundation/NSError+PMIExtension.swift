//
//  NSError_PMIExtension.h
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/15.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//
import Foundation

public extension ErrorType {
    func toNSError(localizedDescription: String? = nil, underlyingError: NSError? = nil, extraInformation: [NSObject : AnyObject]? = nil) -> NSError {
        return NSError(domain: self._domain, code: self._code, desc: localizedDescription, error: underlyingError, info: extraInformation)
    }
    var error: NSError {
        return NSError(domain: self._domain, code: self._code)
    }
}

public extension NSError {

    convenience init(errorType: ErrorType, desc: String? = nil, error: NSError? = nil, info: [NSObject : AnyObject]? = nil) {
        self.init(domain: errorType._domain,
            code: errorType._code,
            desc: desc,
            error: error,
            info: info)
    }
    convenience init(domain: String, code: Int, desc: String? = nil, error: NSError? = nil, info: [NSObject : AnyObject]? = nil) {
        var userInfo: [NSObject : AnyObject] = [:]
        if desc != nil {
            userInfo[NSLocalizedDescriptionKey] = desc
        }

        if error != nil {
            userInfo[NSUnderlyingErrorKey] = error
        }

        if let info = info {
            for (key, value) in info {
                userInfo[key] = value
            }
        }
        self.init(domain: domain, code: code, userInfo: userInfo)
    }

    func underlyingError() -> NSError? {
        return (self.userInfo as NSDictionary).valueForKey(NSUnderlyingErrorKey) as? NSError
    }
}