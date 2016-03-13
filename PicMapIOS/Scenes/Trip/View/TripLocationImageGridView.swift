//
//  TripLocationImageGridView.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/15.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

//@IBDesignable
class HorizontalListView: UIView {
    @IBInspectable var padding: CGFloat = 0
    @IBInspectable var itemSpacing: CGFloat = 0
    @IBInspectable var numberOfColumns: Int = 5

    @IBOutlet weak var contentView: UICollectionView!

    var datas: [AnyObject] = []
    @IBInspectable var cellIdentifier: String = "DefaultCell"

    override func awakeFromNib() {
        self.contentView.dataSource = self;
        self.contentView.delegate = self;
    }

    // MARK: - Interface Builder
    override func prepareForInterfaceBuilder() {
        self.contentView.registerClass(UICollectionViewCell.self,
            forCellWithReuseIdentifier: cellIdentifier)

        datas.append("1")
        datas.append("2")
        datas.append("3")
        datas.append("4")
        datas.append("5")
        datas.append("6")
        datas.append("7")
        datas.append("8")
    }

    func updateCell(cell: UICollectionViewCell, withData data: AnyObject, atIndexPath indexPath: NSIndexPath) {
        #if TARGET_INTERFACE_BUILDER
        cell.layer.borderWidth = 1
        #endif
    }
}

extension HorizontalListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDataSource
    func collectionView(_: UICollectionView, numberOfItemsInSection: Int) -> Int {
        return datas.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.layer.borderWidth = 1
        return cell
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < datas.count || indexPath.row >= 0 {
            updateCell(cell, withData: datas[indexPath.row], atIndexPath: indexPath)
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let canvasWidth = collectionView.frame.width
        let contentWidth = (canvasWidth - padding * 2 - CGFloat(numberOfColumns - 1) * itemSpacing)
        let cellWidth = contentWidth / CGFloat(numberOfColumns)
        return CGSizeMake(cellWidth, cellWidth)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return itemSpacing;
    }
}

class TripLocationImageGridView: HorizontalListView {
    override func updateCell(cell: UICollectionViewCell, withData data: AnyObject, atIndexPath indexPath: NSIndexPath) {
        #if TARGET_INTERFACE_BUILDER
        return
        #endif

        if let imageView = cell.contentView.subviews.first as? UIImageView {
            if let urlString = data as? String {
                imageView.hnk_setImageFromURL(NSURL(string: urlString)!)
            } else if let albumPhotoViewModel = data as?PhotosFromAlbumPhotoViewModel {
                albumPhotoViewModel.loadImage(cell.bounds.size, completion: { (image) -> Void in
                    imageView.image = image
                })
            } else {
                PMILogWarning("not support model:\(data)")
            }
        }
    }
}
