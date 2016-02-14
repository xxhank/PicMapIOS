//
//  SightAnnotation.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/1.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import MapKit

class SightAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return viewModel.coordinate!
        }
    }
    var viewModel: SightViewModel
    init(viewModel: SightViewModel) {
        self.viewModel = viewModel;
    }
}