//
//  TripEditViewController.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/3/13.
//  Copyright (c) 2016年 wangchaojs02. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import PKHUD

protocol TripEditViewControllerInput: class
{
    func displayTrip(viewModel: ViewModel<TripEditViewModel>)
}

protocol TripEditViewControllerOutput
{
    var tripModel: [String: [PhotoGroup]]? { set get }
    func formatModel(request: TripEditFormatModelRequest)
    func saveTrip()
    func cacheTrip()
}

class TripEditViewController: UIViewController, TripEditViewControllerInput
{
    // MARK: Clean Swift
    var output: TripEditViewControllerOutput!
    var router: TripEditRouter!

    // MARK: tripView
    @IBOutlet weak var tripView: UITableView!
    var proxy: MMArrayTableViewProxy!
}

// MARK: - View Controller
extension TripEditViewController {
    // MARK: Object lifecycle
    override func awakeFromNib()
    {
        super.awakeFromNib()
        TripEditConfigurator.sharedInstance.configure(self)
    }

    // MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupTripView()

        doSomethingOnLoad()
    }

    override func viewWillDisappear(animated: Bool) {
        if self.isMovingFromParentViewController() {
            /// pop out
        }
    }
}

// MARK: - tripView
extension TripEditViewController {
    // MARK: Setup
    func setupTripView() {
        proxy = MMArrayTableViewProxy(tableView: tripView, identifier: { (tableView, indexPath) -> String in
            return "TripEditLocationCell"
        })
    }
    // MARK: Load
    func doSomethingOnLoad()
    {
        // NOTE: Ask the Interactor to do some work
        let request = TripEditFormatModelRequest()
        output.formatModel(request)
    }

    // MARK: Display
    func displayTrip(viewModel: ViewModel<TripEditViewModel>)
    {
        switch viewModel {
        case .Error(let error):
            PKHUD.sharedHUD.contentView = PKHUDTextView(text: error.localizedDescription)
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 2.0)
            break

        case .Result(let result):
            if proxy != nil {
                proxy.datas = result.locations
            }
            break
        }
    }
    @IBAction func saveTrip(sender: AnyObject) {
        output.saveTrip()
    }
}