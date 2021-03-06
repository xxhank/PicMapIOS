//
//  CameraInteractor.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/5.
//  Copyright (c) 2016年 wangchaojs02. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

enum CameraInteractorError: ErrorType {
    case General
}

protocol CameraInteractorOutput
{
    func presentPhotosFromAlbum(response: Response<Camera_LoadPhotosFromAlbum_Response>)
}

class CameraInteractor: CameraInteractorInput
{
    var output: CameraInteractorOutput!
    var worker: LoadPhotosFromAlbumWorker!

    var loadedPhotos: [PhotoGroup] = []
    var pickedIndexPaths: [Int: NSMutableDictionary] = [:]

    /**
     选中的图片, 结构如下
     ```
     ["photos": [
     >>>>{date:NSData
     >>>>coordinate:CLLocationCoordinate2D
     >>>>city:String
     >>>>street:String
     >>>>locationString
     >>>>photos:[{"asset": PHAsset}]}
     ]]
     ```
     */
    private var _pickedPhotos : [String: [PhotoGroup]] = ["photos": []]
    var pickedPhotos: [String: [PhotoGroup]]? {
        if pickedIndexPaths.isEmpty {
            return _pickedPhotos
        }

        var pickedSections: [PhotoGroup] = []
        for (section, photoIndexs) in pickedIndexPaths {
            let sectionData = self.loadedPhotos[section]
            let sectionPhotos = sectionData.photos

            var photos: [Photo] = []

            photoIndexs.enumerateKeysAndObjectsUsingBlock({ (key, value, stop) -> Void in
                let photoIndex = (key as! NSNumber).integerValue
                photos.append(sectionPhotos[photoIndex])
            })

            let pickedSection = sectionData.clone()
            pickedSection.photos = photos
            pickedSections.append(pickedSection)
        }
        _pickedPhotos = ["photos": pickedSections]
        pickedIndexPaths.removeAll(keepCapacity: true)
        return _pickedPhotos
    }
    func loadPhotosFromAlbum(request: Camera_LoadPhotosFromAlbum_Request) -> () {
        if worker == nil {
            worker = LoadPhotosFromAlbumWorker()
        }
        worker.loadPhotosFromAlbum { (result) -> Void in
            switch result {
            case .Success(let result):
                self.loadedPhotos = result["groups"]!
                let response = Camera_LoadPhotosFromAlbum_Response(photos: result)
                self.output.presentPhotosFromAlbum(Response.Result(response))
                break
            case .Failure(let error):
                self.output.presentPhotosFromAlbum(Response.Error(error))
                break
            }
        }
    }

    func pickPhotoAtIndexPath(indexPath: NSIndexPath, picked: Bool) {
        var section = pickedIndexPaths[indexPath.section]
        if section == nil {
            section = NSMutableDictionary(capacity: 1)
            pickedIndexPaths[indexPath.section] = section
        }

        if picked {
            section?.setObject(1, forKey: indexPath.row)
        } else {
            section?.removeObjectForKey(indexPath.row)
        }
    }
}