//
//  MMArrayCollectionViewProxy.swift
//  Memo
//
//  Created by wangchaojs02 on 15/11/1.
//  Copyright © 2015年 wangchaojs02. All rights reserved.
//

import UIKit
import ReactiveCocoa

typealias MMCollectionViewCellBuilder = (collectionView: UICollectionView, indexPath:NSIndexPath)->UICollectionViewCell;
typealias MMCollectionViewCellIdentifier = (collectionView: UICollectionView, indexPath:NSIndexPath)->String;
typealias MMCollectionViewCellModifier = ( collectionView: UICollectionView, collectionViewCell:UICollectionViewCell, cellData :AnyObject)-> ();
typealias MMCollectionViewCellMeasurer = (collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, indexPath: NSIndexPath) -> CGSize



class MMArrayCollectionViewProxy: NSObject  {
    var collectionView:UICollectionView?{
        didSet{
            self.collectionView?.dataSource = self;
            self.collectionView?.delegate   = self;
        }
    }
    var datas:[AnyObject]?{
        didSet{
            self.collectionView?.dataSource = self;
            self.collectionView?.delegate   = self;

            self.collectionView?.reloadData()
        }
    }
    var identifier:MMCollectionViewCellIdentifier
    var builder:MMCollectionViewCellBuilder
    var modifier:MMCollectionViewCellModifier
    var measurer:MMCollectionViewCellMeasurer

    required init(
        collectionView:UICollectionView
        ,identifier:MMCollectionViewCellIdentifier
        ,builder:MMCollectionViewCellBuilder
        ,modifier:MMCollectionViewCellModifier
        ,measurer:MMCollectionViewCellMeasurer) {
            self.collectionView = collectionView

            self.identifier = identifier
            self.builder = builder
            self.modifier = modifier
            self.measurer = measurer
            super.init()
    }
    
    let (selectSignal, selectSink) = Signal<(NSIndexPath, AnyObject?), NSError>.pipe();
}

extension MMArrayCollectionViewProxy:UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let datas = self.datas {
            return datas.count;
        }
        return 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        if let datas = self.datas{
            let identifier:String = self.identifier(collectionView: collectionView, indexPath: indexPath)
            let cell:UICollectionViewCell  = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
            let cellData = datas[indexPath.row];
            self.modifier(collectionView: collectionView, collectionViewCell: cell, cellData: cellData)
            return cell;
        }
        
        let textLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 100, height: 100))
        textLabel.text = "Can not create cell at \(indexPath)";
        textLabel.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        let cell = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cell.contentView.addSubview(textLabel)
        return cell;
    }
}

extension MMArrayCollectionViewProxy:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return self.measurer(collectionView: collectionView, collectionViewLayout: collectionViewLayout, indexPath: indexPath);
    }
}

extension MMArrayCollectionViewProxy:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let datas = self.datas!
        let cellData = datas[indexPath.row];
        selectSink.sendNext((indexPath,cellData))
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
func MMCollectionViewCellSquareSize(collectionView:UICollectionView, column:Int) -> CGSize {
    let columnCount:CGFloat = CGFloat(column);
    let width = collectionView.bounds.size.width
    let collectionViewLayout   = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let spacing = collectionViewLayout.minimumInteritemSpacing;
    let cellWidth = (width - spacing*(columnCount-1))/columnCount;
    return CGSize(width: cellWidth, height: cellWidth)
}

/**
 计算单页cell的大小,高度为collectionView的高度
 
 - Parameter collectionView: cell所属于的view
 - Throws:  无
 - Returns: cell的尺寸
 */
func MMCollectionViewCellSingleColumnSize(collectionView:UICollectionView) -> CGSize {
    let columnCount:CGFloat = 1.0;
    let width = collectionView.bounds.size.width
    let height = collectionView.bounds.size.height
    let collectionViewLayout   = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let spacing = collectionViewLayout.minimumInteritemSpacing;
    let cellWidth = (width - spacing*(columnCount-1))/columnCount;
    return CGSize(width: cellWidth, height: height)
}
