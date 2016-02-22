//
//  TouristTripsViewController.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/19.
//  Copyright (c) 2016年 wangchaojs02. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

class TouristTripsViewController: UIViewController
{
    var router: TouristRouter!
    var tripList: [TripCellViewModel] = [] {
        didSet {
            displayTripList(tripList)
        }
    }
    var proxy: MMArrayTableViewProxy?
    @IBOutlet weak var tripListView: UITableView!
    // MARK: Object lifecycle

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    // MARK: View lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupTripListView()
    }

    // MARK: Event handling
    // MARK: Display logic

    func displayTripList(viewModel: [TripCellViewModel])
    {
        proxy?.datas = viewModel
    }

    func setupTripListView() {
        proxy = MMArrayTableViewProxy(tableView: self.tripListView, identifier: { (tableView, indexPath) -> String in
            return "TouristTripListCell"
        })
    }
}