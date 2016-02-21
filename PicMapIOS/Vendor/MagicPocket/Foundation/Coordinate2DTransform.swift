//
//  Coordinate2DTransform.swift
//  Memo
//
//  Created by wangchaojs02 on 15/10/28.
//  Copyright © 2015年 wangchaojs02. All rights reserved.
//

import CoreLocation
import XCGLogger

extension Double {
    init?(object: AnyObject?) {
        guard object != nil else { return nil }

        if let stringValue = object as? String {
            self.init(stringValue)
        } else if let doubleValue = object as? Double {
            self.init(doubleValue)
        } else {
            XCGLogger.error("cannot init Double from \(object)")
            return nil
        }
    }
}

extension CLLocationCoordinate2D {
    init?(coordinate: [String: AnyObject]?) {
        guard coordinate != nil else { return nil }
        if let latitude = Double(object: coordinate!["lat"]!),
            let longitude = Double(object: coordinate!["lng"]!) {
                self.init(latitude: latitude, longitude: longitude)
            } else {
                XCGLogger.error("cannot init CLLocationCoordinate2D from \(coordinate)")
                return nil
            }
    }
}

import ObjectMapper

public class CoordinateTransform: TransformType {
    public typealias Object = CLLocationCoordinate2D
    public typealias JSON = [String: AnyObject]

    public init() { }

    public func transformFromJSON(value: AnyObject?) -> Object? {
        return CLLocationCoordinate2D(coordinate: value as? [String: AnyObject])
    }

    public func transformToJSON(value: Object?) -> JSON? {
        if let coordinate = value {
            return ["lat" : "\(coordinate.latitude)",
                "lng": "\(coordinate.longitude)"]
        }
        return nil
    }
}
