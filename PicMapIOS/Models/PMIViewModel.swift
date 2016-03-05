//
//  PMIViewModel.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/5.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Foundation
import ObjectMapper

class PMIViewModel<T: Mappable>: Mappable {
    class func viewModelFromDictonary(dictonary: [String: AnyObject]) -> T? {
        return Mapper<T>().map(dictonary)
    }
    required init?(_ map: Map) {
    }
    func mapping(map: Map) -> () {
    }
}
