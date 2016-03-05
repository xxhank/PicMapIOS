//
//  CameraPresenter.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/5.
//  Copyright (c) 2016年 wangchaojs02. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

let CameraPresenterErrorDomain = "CameraPresenter"
enum CameraPresenterError: ErrorType {
    case General
}

class CameraPresenter: CameraPresenterInput
{
    weak var output: CameraPresenterOutput!

    // MARK: - Presentation logic

    func presentPhotosFromAlbum(response: Response<Camera_LoadPhotosFromAlbum_Response>) -> () {
        switch response {
        case .Error(let error):
            output.displayPhotosFromAlbum(ViewModel.Error(error))
            break
        case .Result(let result):
            let viewModel = PhotosFromAlbumViewModel.viewModelFromDictonary(result.photos)
            output.displayPhotosFromAlbum(ViewModel.Result(viewModel!))
            break
        }
    }
}
