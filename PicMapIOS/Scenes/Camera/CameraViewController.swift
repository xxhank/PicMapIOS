//
//  CameraViewController.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/5.
//  Copyright (c) 2016年 wangchaojs02. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import PKHUD

protocol CameraViewControllerInput: class {
    func displayPhotosFromAlbum(viewModel: ViewModel<PhotosFromAlbumViewModel>)
}

protocol CameraViewControllerOutput {
    func loadPhotosFromAlbum(request: Camera_LoadPhotosFromAlbum_Request)
}

class CameraViewController: UIViewController, CameraViewControllerInput {
    var output: CameraViewControllerOutput!
    var router: CameraRouter!

    @IBOutlet weak var photoListView: UICollectionView!
    var proxy: MM2DArrayCollectionViewProxy?
}

// MARK: - lifecycle
extension CameraViewController {
    // MARK: Object lifecycle
    override func awakeFromNib()
    {
        super.awakeFromNib()
        CameraConfigurator.sharedInstance.configure(self)
    }

    // MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupPhotoListView()

        doSomethingOnLoad()
    }
}

// MARK: - Event handling
extension CameraViewController {
    func doSomethingOnLoad()
    {
        let request = Camera_LoadPhotosFromAlbum_Request()
        output.loadPhotosFromAlbum(request)
    }
}

// MARK: - Display logic
extension CameraViewController {
    func displayPhotosFromAlbum(viewModel: ViewModel<PhotosFromAlbumViewModel>)
    {
        switch viewModel {
        case .Error(let error):
            PKHUD.sharedHUD.contentView = PKHUDTextView(text: error.localizedDescription)
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 2.0)
            break

        case .Result(let result):
            proxy?.sections = result.sections
            proxy?.datas = result.photoViewModels
            break
        }
    }
}

// MARK: - Photo List View
extension CameraViewController {
    func setupPhotoListView() {
        proxy = MM2DArrayCollectionViewProxy(collectionView: photoListView, identifier: { (collectionView, indexPath) -> String in
            return "CamerPhotosCell"
        }, sectionIdentifier: { (collectionView, kind, indexPath) -> String in
            return "CamerPhotosSectionHeader"
        }, builder: { (collectionView, indexPath) -> UICollectionViewCell? in
            return nil
        }, measurer: { (collectionView, collectionViewLayout, indexPath) -> CGSize in
            return MMCollectionViewCellSquareSize(collectionView, column: 4)
        })
    }
}
