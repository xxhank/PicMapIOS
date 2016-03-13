//
//  TripEditPresenter.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/13.
//  Copyright (c) 2016年 wangchaojs02. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

enum TripEditPresenterError: ErrorType {
    case General
}

class TripEditPresenter: TripEditPresenterInput
{
    weak var output: TripEditPresenterOutput!

    // MARK: - Presentation logic
    func presentTripModel(response: Response<TripEditFormatModelResponse>)
    {
        switch response {
        case .Error(let error):
            output.displayTrip(ViewModel.Error(error))
            break
        case .Result(let result):
            if let viewModel = TripEditViewModel.viewModelFromDictonary(result.tripModel) {
                output.displayTrip(ViewModel.Result(viewModel))
            } else {
                output.displayTrip(TripEditPresenterError.General.toViewModel())
            }
            break
        }
    }
}
