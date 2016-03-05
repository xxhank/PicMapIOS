//
//  TouristPhotosController.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/19.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class TouristPhotosController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var photoListView: UICollectionView!

    //
    var photoDateList: [String]!
    var photoList: [[PhotoViewModel]]! {
        didSet {
            diplayPhotoList()
        }
    }

    var proxy: MM2DArrayCollectionViewProxy!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPhotoListView()

        diplayPhotoList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TouristPhotosController {
    func setupPhotoListView() {
        proxy = MM2DArrayCollectionViewProxy(collectionView: self.photoListView,
            identifier: { (collectionView, indexPath) -> String in
                return "photo_cell"
            }, sectionIdentifier: { (collectionView, kind, indexPath) -> String in
                return "photo_date_header"
            }, builder: { (collectionView, indexPath) -> UICollectionViewCell? in
                return nil
            }, measurer: { (collectionView, collectionViewLayout, indexPath) -> CGSize in
                return MMCollectionViewCellSquareSize(collectionView, column: 3)
            })
    }
    func diplayPhotoList() {
        if let proxy = self.proxy {
            proxy.sections = photoDateList
            proxy.datas = photoList
        }
    }
}