//
//  PMIAPI.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/1.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Alamofire
import SwiftTask

typealias PMIAPIProgress = (bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
typealias PMIAPITask = Task<PMIAPIProgress, AnyObject, NSError>

let PMIAPIErrorDomain = "PMIAPI"
let PMIAPIErrorRequestKey = "request"

enum PMIAPIError: ErrorType {
    case NotResult
}

class PMIAPI {
    class func fetchJSON(action: String, parameters: [String: String], host: String = "http://1.picmapapi.applinzi.com/") -> PMIAPITask {
        return PMIAPITask { progress, fullfil, reject, configure in
            Alamofire.request(.GET, host + action, parameters: parameters)
                .responseJSON(completionHandler: { (response) -> Void in
                    if let error = response.result.error {
                        reject(error)
                    } else {
                        if let value = response.result.value {
                            fullfil(value)
                        } else {
                            let error = NSError(domain: PMIAPIErrorDomain,
                                code: PMIAPIError.NotResult,
                                desc: "not result value",
                                info: [PMIAPIErrorRequestKey: response.request!])
                            reject(error)
                        }
                    }
                })
        }
    }
}