//
//  MMArrayCollectionViewProxy.swift
//  Memo
//
//  Created by wangchaojs02 on 15/11/1.
//  Copyright © 2015年 wangchaojs02. All rights reserved.
//

import UIKit
import ReactiveCocoa

typealias MMCollectionViewCellBuilder = (collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell?;
typealias MMCollectionViewCellIdentifier = (collectionView: UICollectionView, indexPath: NSIndexPath) -> String;
typealias MMCollectionViewCellMeasurer = (collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, indexPath: NSIndexPath) -> CGSize

typealias MMCollectionViewSectionIdentifier = (collectionView: UICollectionView, kind: String, indexPath: NSIndexPath) -> String ;

class MMArrayCollectionViewProxy: NSObject {
    typealias IndexPathViewModel = (NSIndexPath, AnyObject?)

    var collectionView: UICollectionView? {
        didSet {
            self.collectionView?.dataSource = self;
            self.collectionView?.delegate = self;
        }
    }
    var datas: [AnyObject]! {
        didSet {
            self.collectionView?.dataSource = self;
            self.collectionView?.delegate = self;

            self.collectionView?.reloadData()
        }
    }
    var identifier: MMCollectionViewCellIdentifier
    var builder: MMCollectionViewCellBuilder?
    var measurer: MMCollectionViewCellMeasurer
    var templateCells: [String: UICollectionViewCell] = [:]
    required init(
        collectionView: UICollectionView
    , identifier: MMCollectionViewCellIdentifier
    , measurer: MMCollectionViewCellMeasurer) {
            self.collectionView = collectionView
            self.identifier = identifier
            self.measurer = measurer

            super.init()

            self.collectionView?.dataSource = self;
            self.collectionView?.delegate = self;
        }
    var selectAction: Action<IndexPathViewModel , Void, NSError>?
    var deselectAction: Action<IndexPathViewModel , Void, NSError>?
    
    // MARK: - Data Mapping
    func datasInSection(section: Int) -> [AnyObject] {
        return self.datas
    }

    func dataAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return self.datasInSection(0) [indexPath.row]
    }
}

// class

extension MMArrayCollectionViewProxy: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let datas = self.datas {
            return datas.count;
        }
        return 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier: String = self.identifier(collectionView: collectionView, indexPath: indexPath)
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        return cell;
    }
}

extension MMArrayCollectionViewProxy: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let identifier: String = self.identifier(collectionView: collectionView, indexPath: indexPath)

        var templateCell = templateCells[identifier]
        if templateCell == nil {
            templateCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
            templateCells[identifier] = templateCell
        }
        let cellView = templateCell as UICollectionViewCell!
        if var cell = cellView as? SupportViewModel {
            let cellData = self.dataAtIndexPath(indexPath)
            cell.viewModel = cellData

            let heightFenceConstraint = NSLayoutConstraint(item: cellView.contentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: collectionView.frame.height)
            cellView.contentView.addConstraint(heightFenceConstraint)
            // Auto layout engine does its math
            let fittingSize = cellView.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)

            cellView.contentView.removeConstraint(heightFenceConstraint) ;

            return fittingSize
        }

        return CGSizeZero
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return self.measurer(collectionView: collectionView, collectionViewLayout: collectionViewLayout, indexPath: indexPath) ;
    }
}

extension MMArrayCollectionViewProxy: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if var view = cell as? SupportViewModel {
            view.viewModel = self.dataAtIndexPath(indexPath)
        }
        else {
            PMILogWarning("\(cell) not conforms to SupportViewModel")
        }
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cellData = self.dataAtIndexPath(indexPath)
        selectAction?.apply((indexPath, cellData)).start()
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cellData = self.dataAtIndexPath(indexPath)
        deselectAction?.apply((indexPath, cellData)).start()
    }
}

class MM2DArrayCollectionViewProxy: MMArrayCollectionViewProxy {
    var sections: [AnyObject]!
    var sectionIdentifier: MMCollectionViewSectionIdentifier
    required init(
        collectionView: UICollectionView
    , identifier: MMCollectionViewCellIdentifier
    , sectionIdentifier: MMCollectionViewSectionIdentifier
    , builder: MMCollectionViewCellBuilder
    , measurer: MMCollectionViewCellMeasurer
    ) {
        self.sectionIdentifier = sectionIdentifier
        super.init(collectionView: collectionView,
            identifier: identifier,
            measurer: measurer)
    }

    required init(collectionView: UICollectionView,
        identifier: MMCollectionViewCellIdentifier,
        measurer: MMCollectionViewCellMeasurer) {
            fatalError("init(collectionView:identifier:builder:modifier:measurer:) has not been implemented")
        }

    // MARK: - Data Mapping
    override func datasInSection(section: Int) -> [AnyObject] {
        if let datas = self.datas {
            return datas[section] as! [AnyObject]
        } else {
            PMILogWarning("covert \(self.datas) to [[any]] failed")
        }
        return []
    }
    override func dataAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return self.datasInSection(indexPath.section) [indexPath.row]
    }
}

// class

extension MM2DArrayCollectionViewProxy /*: UICollectionViewDataSource*/ {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let sections = sections {
            return sections.count
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let datas = self.datasInSection(section)
        return datas.count;
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        let identifier: String = self.sectionIdentifier(collectionView: collectionView, kind: kind, indexPath: indexPath)
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: identifier, forIndexPath: indexPath)

        return view
    }

    func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {

        if var view = view as? SupportViewModel {
            if let sections = sections {
                view.viewModel = sections[indexPath.section]
            }
        }
        else {
            PMILogWarning("\(view) not conforms to SupportViewModel")
        }
    }
}

// MARK: 常用的计算方法

/**
 根据列数,计算正方形cell的尺寸
 ```
 MMCollectionViewCellSquareSize(collectionView, 3)
 ```

 - Parameter collectionView: cell所属于的view
 - Parameter column: 列数

 - Throws:  none

 - Returns: cell的尺寸
 */
func MMCollectionViewCellSquareSize(collectionView: UICollectionView, column: Int) -> CGSize {
    let columnCount: CGFloat = CGFloat(column) ;
    let width = collectionView.bounds.size.width
    let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let spacing = collectionViewLayout.minimumInteritemSpacing;
    let cellWidth = (width - spacing * (columnCount - 1)) / columnCount;
    return CGSize(width: cellWidth, height: cellWidth)
}

/**
 计算单页cell的大小,高度为collectionView的高度

 - Parameter collectionView: cell所属于的view
 - Throws:  无
 - Returns: cell的尺寸
 */
func MMCollectionViewCellSingleColumnSize(collectionView: UICollectionView) -> CGSize {
    let columnCount: CGFloat = 1.0;
    let width = collectionView.bounds.size.width
    let height = collectionView.bounds.size.height
    let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let spacing = collectionViewLayout.minimumInteritemSpacing;
    let cellWidth = (width - spacing * (columnCount - 1)) / columnCount;
    return CGSize(width: cellWidth, height: height)
}
