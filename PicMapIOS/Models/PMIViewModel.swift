//
//  PMIViewModel.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/5.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Foundation
import ObjectMapper

protocol MappableViewModel: Mappable {
    typealias ViewModel: Mappable
    static func viewModelFromDictonary(dictonary: [String: AnyObject]) -> ViewModel?;
}

extension MappableViewModel {
    static func viewModelFromDictonary(dictonary: [String: AnyObject]) -> ViewModel? {
        return Mapper<ViewModel>().map(dictonary)
    }
}

class PMIMappableViewModel: MappableViewModel {
    typealias ViewModel = PMIMappableViewModel

    required init?(_ map: Map) {
    }
    func mapping(map: Map) -> () {
    }
}
