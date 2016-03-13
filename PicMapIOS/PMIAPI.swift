//
//  PMIAPI.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/1.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Alamofire
import SwiftTask
import Haneke

typealias PMIAPIProgress = (bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
typealias PMIAPITask = Task<PMIAPIProgress, AnyObject, NSError>

let PMIAPIErrorRequestKey = "request"

enum PMIAPIError: ErrorType {
    case NotResult
}

class PMIAPI {
    class func fetchJSON(action: String, parameters: [String: String], host: String = "http://1.picmapapi.applinzi.com/") -> PMIAPITask {

        return PMIAPITask { (progress, fulfill, reject, configure) -> Void in
            let cache = Cache<JSON>(name: "github")
            let URL = NSURL(string: host + action)!
            cache.fetch(URL: URL).onSuccess({ (JSON) -> () in
                var value: AnyObject? = nil
                switch JSON {
                case .Array(let arrayValue):
                    value = arrayValue
                    break;
                case .Dictionary(let dictValue):
                    value = dictValue
                    break;
                }

                if value != nil {
                    fulfill(value!)
                } else {
                    let error = NSError(
                        errorType: PMIAPIError.NotResult,
                        desc: "not result value",
                        info: [PMIAPIErrorRequestKey: URL])
                    reject(error)
                }
            }).onFailure({ (error: NSError?) -> () in
                reject(error!)
            })
        }
    }
}