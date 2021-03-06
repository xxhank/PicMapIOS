//
//  TripPresenter.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/15.
//  Copyright (c) 2016年 wangchaojs02. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

class TripPresenter: TripPresenterInput
{
    weak var output: TripPresenterOutput!

    // MARK: - Presentation logic
    func presentTripDetail(response: Response<Trip_FetchTripDetail_Response>) -> () {
        switch response {
        case .Error(let error):
            output.displayTripDetail(ViewModel.Error(error))
            break
        case .Result(let result):
            let viewModel = Trip_FetchTripDetail_ViewModel(detail: TripDetailViewModel.viewModelFromDictonary(result.tripData)!)
            output.displayTripDetail(ViewModel.Result(viewModel))
            break
        }
    }
}
