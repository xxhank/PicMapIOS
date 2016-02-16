//
//  LocationAnnotation.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/16.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return viewModel.coordinate
        }
    }
    var viewModel: TripLocationCellViewModel
    init(viewModel: TripLocationCellViewModel) {
        self.viewModel = viewModel;
    }
}