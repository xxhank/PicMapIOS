//
//  NSError_PMIExtension.h
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/15.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//
import Foundation

public extension NSError {

    convenience init(domain: String, code: ErrorType, desc: String? = nil, error: NSError? = nil, info: [NSObject : AnyObject]? = nil) {
        self.init(domain: domain,
            code: code._code,
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