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

typealias MMTableViewCellBuilder = (tableView: UITableView, indexPath: NSIndexPath, identifier: String) -> UITableViewCell?;
typealias MMTableViewCellIdentifier = (tableView: UITableView, indexPath: NSIndexPath) -> String;

class MMArrayTableViewProxy: NSObject {
    var tableView: UITableView? {
        didSet {
            self.tableView?.dataSource = self;
            self.tableView?.delegate = self;
        }
    }
    var datas: [AnyObject]? {
        didSet {
            self.tableView?.dataSource = self;
            self.tableView?.delegate = self;

            self.tableView?.reloadData()
        }
    }
    var identifier: MMTableViewCellIdentifier
    var builder: MMTableViewCellBuilder?

    required init(
        tableView: UITableView, identifier: MMTableViewCellIdentifier) {
            self.tableView = tableView
            self.identifier = identifier
            super.init()
            self.tableView?.tableFooterView = UIView()
        }

    let (selectSignal, selectSink) = Signal < (NSIndexPath, AnyObject?), NSError > .pipe()
}

extension MMArrayTableViewProxy: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let datas = self.datas {
            return datas.count;
        }
        return 0;
    }

    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = self.identifier(tableView: tableView, indexPath: indexPath)
        var cell: UITableViewCell? = nil
        if let dequeueCell = tableView.dequeueReusableCellWithIdentifier(identifier) {
            cell = dequeueCell;
        } else {
            if let builder = self.builder {
                cell = builder(tableView: tableView, indexPath: indexPath, identifier: identifier)!
            }
        }
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: ".Default") ;
            cell!.textLabel?.text = "Can not create cell at \(indexPath)";
        }
        cell!.selectionStyle = .None;
        return cell!;
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let datas = self.datas {
            let identifier: String = self.identifier(tableView: tableView, indexPath: indexPath)
            return tableView.fd_heightForCellWithIdentifier(identifier) { (tableViewCell: AnyObject!) -> Void in
                if var cell = tableViewCell as? SupportViewModel {
                    let cellData = datas[indexPath.row]
                    cell.viewModel = cellData
                }
            }
        }
        return UITableViewAutomaticDimension;
    }
}

extension MMArrayTableViewProxy: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let datas = self.datas!
        let cellData = datas[indexPath.row] ;
        self.selectSink.sendNext((indexPath, cellData))
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let datas = self.datas {
            if var cell = cell as? SupportViewModel {
                let cellData = datas[indexPath.row]
                cell.viewModel = cellData
            }
        }
    }
}