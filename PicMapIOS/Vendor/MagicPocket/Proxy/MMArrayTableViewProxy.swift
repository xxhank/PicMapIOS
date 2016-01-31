//
//  MMArrayTableViewProxy.swift
//  Memo
//
//  Created by wangchaojs02 on 15/11/1.
//  Copyright © 2015年 wangchaojs02. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell
import ReactiveCocoa

typealias MMTableViewCellBuilder = (tableView: UITableView, indexPath:NSIndexPath)->UITableViewCell;
typealias MMTableViewCellIdentifier = (tableView: UITableView, indexPath:NSIndexPath)->String;
typealias MMTableViewCellModifier = (tableView: UITableView, tableViewCell:UITableViewCell, cellData :AnyObject)-> ();

class MMArrayTableViewProxy: NSObject  {
    var tableView:UITableView?{
        didSet{
            self.tableView?.dataSource = self;
            self.tableView?.delegate   = self;
        }
    }
    var datas:[AnyObject]?{
        didSet{
            self.tableView?.dataSource = self;
            self.tableView?.delegate   = self;

            self.tableView?.reloadData()
        }
    }
    var identifier:MMTableViewCellIdentifier
    var builder:MMTableViewCellBuilder
    var modifier:MMTableViewCellModifier

    required init(
        tableView:UITableView
        ,identifier:MMTableViewCellIdentifier
        ,builder:MMTableViewCellBuilder
        ,modifier:MMTableViewCellModifier) {
            self.tableView = tableView

            self.identifier = identifier
            self.builder = builder
            self.modifier = modifier
            super.init()
    }
    
    let (selectSignal, selectSink) = Signal<(NSIndexPath, AnyObject?), NSError>.pipe()
}

extension MMArrayTableViewProxy:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let datas = self.datas {
            return 5;//datas.count;
        }
        return 0;
    }

     internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if let datas = self.datas{
            let identifier:String = self.identifier(tableView: tableView, indexPath: indexPath)
            var cell:UITableViewCell
            if let dequeueCell = tableView.dequeueReusableCellWithIdentifier(identifier){
                cell = dequeueCell;
            } else {
                cell = self.builder(tableView: tableView, indexPath: indexPath);
            }
            let cellData = datas[indexPath.row];
            self.modifier(tableView: tableView, tableViewCell: cell, cellData: cellData)
            cell.selectionStyle = .None;
            return cell;
        }

        let cell = UITableViewCell(style: .Default, reuseIdentifier: ".Default");
        cell.textLabel?.text = "Can not create cell at \(indexPath)";
        return cell;
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let datas = self.datas{
            let identifier:String = self.identifier(tableView: tableView, indexPath: indexPath)
            return tableView.fd_heightForCellWithIdentifier(identifier) { (tableViewCell:AnyObject!) -> Void in
                let cellData = datas[indexPath.row];
                self.modifier(tableView: tableView, tableViewCell: tableViewCell as! UITableViewCell, cellData: cellData)
            }
        }
        return UITableViewAutomaticDimension;
    }
}

extension MMArrayTableViewProxy:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let datas = self.datas!
        let cellData = datas[indexPath.row];
        self.selectSink.sendNext((indexPath, cellData))
    }
}