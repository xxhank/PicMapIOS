//
//  PlantInteractor.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/1/31.
//  Copyright (c) 2016年 wangchaojs02. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import CoreLocation
import XCGLogger

let PlantInteractorErrorDomain = "PlantInteractor"
enum PlantInteractorError: Int {
    case General
    case GeocoderFailed
}

protocol PlantInteractorInput
{
    func fetchLocationInformation(request: Plant_FormatLocation_Requset)
}

protocol PlantInteractorOutput
{
    func presentLocationInformation(response: Response<Plant_FormatLocation_Response, NSError>)
}

class PlantInteractor: PlantInteractorInput
{
    var output: PlantInteractorOutput!
    var worker: PlantWorker!

    var geocoder = CLGeocoder()

    // MARK: Business logic
    func fetchLocationInformation(request: Plant_FormatLocation_Requset)
    {
        XCGLogger.info("\(self.geocoder.geocoding)")
        if (self.geocoder.geocoding) {
            return;
        }

        self.geocoder.reverseGeocodeLocation(request.location) { (placemarks, error: NSError?) -> Void in
            // CLPlacemark
            var response: Response<Plant_FormatLocation_Response, NSError> = .Error(
                NSError(domain: PlantInteractorErrorDomain,
                code: PlantInteractorError.General.rawValue,
                userInfo: [:]))

            defer {
                self.output.presentLocationInformation(response)
            }
            guard let placemark = placemarks else {
                XCGLogger.error("\(error)")
                response = .Error(NSError(domain: PlantInteractorErrorDomain,
                    code: PlantInteractorError.GeocoderFailed.rawValue,
                    userInfo: [
                    NSLocalizedDescriptionKey: mapCLErrorCode((error?.code)!),
                    "origin": error!]))
                return
            }

            let place = placemark.first! as CLPlacemark
            guard let information = place.addressDictionary else {
                response = .Error(NSError(domain: PlantInteractorErrorDomain,
                    code: PlantInteractorError.General.rawValue,
                    userInfo: [:]))
                return }

            response = .Result(Plant_FormatLocation_Response(information: information))
        }
    }
}

func mapCLErrorCode(errorCode: Int) -> String {
    if let error = CLError(rawValue: errorCode) {
        switch error {
        case .LocationUnknown: return "LocationUnknown"
        case .Denied: return "Denied"
        case .Network: return "Network"
        case .HeadingFailure: return "HeadingFailure"
        case .RegionMonitoringDenied: return "RegionMonitoringDenied"
        case .RegionMonitoringFailure: return "RegionMonitoringFailure"
        case .RegionMonitoringSetupDelayed: return "RegionMonitoringSetupDelayed"
        case .RegionMonitoringResponseDelayed: return "RegionMonitoringResponseDelayed"
        case .GeocodeFoundNoResult: return "GeocodeFoundNoResult"
        case .GeocodeFoundPartialResult: return "GeocodeFoundPartialResult"
        case .GeocodeCanceled: return "GeocodeCanceled"
        case .DeferredFailed: return "DeferredFailed"
        case .DeferredNotUpdatingLocation: return "DeferredNotUpdatingLocation"
        case .DeferredAccuracyTooLow: return "DeferredAccuracyTooLow"
        case .DeferredDistanceFiltered: return "DeferredDistanceFiltered"
        case .DeferredCanceled: return "DeferredCanceled"
        case .RangingUnavailable: return "RangingUnavailable"
        case .RangingFailure: return "RangingFailure"
        }
    }
    return "No CLError Error";
}
