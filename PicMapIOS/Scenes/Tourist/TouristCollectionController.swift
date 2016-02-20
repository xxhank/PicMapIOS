//
//  TouristCollectionController.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/19.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class TouristCollectionController: UIViewController {

    @IBOutlet weak var countryListView: UICollectionView!
    @IBOutlet weak var cityListView: UICollectionView!
    @IBOutlet weak var locationListView: UITableView!

    var countryProxy: MMArrayCollectionViewProxy?
    var cityProxy: MMArrayCollectionViewProxy?
    var locationProxy: MMArrayTableViewProxy?

    var countries: [CountryElement]!
    var cities: [ProvinceElement]!
    var locations: [LocationElement]!

    var locationList: WorldElement = [] {
        didSet {
            displayLocations()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCountryListView()
        setupCityListView()
        setupLocationListView()

        displayLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func displayLocations() {
        if locationList.count == 0 {
            return
        }
        countries = locationList
        cities = countries.first?.components as! [LocationComponent]
        locations = cities.first?.components as! [LocationElement]

        countryProxy?.datas = countries
        cityProxy?.datas = cities
        locationProxy?.datas = locations
    }

    func setupCountryListView() {
        countryProxy = MMArrayCollectionViewProxy(collectionView: self.countryListView, identifier: { (collectionView, indexPath) -> String in
            return "TouristLocationsCountryCell"
        }, measurer: { (collectionView, collectionViewLayout, indexPath) -> CGSize in
            return CGSize(width: 75, height: 75)
        })
    }

    func setupCityListView() {
        cityProxy = MMArrayCollectionViewProxy(collectionView: self.cityListView, identifier: { (collectionView, indexPath) -> String in
            return "TouristLocationsCityCell"
        }, measurer: { (collectionView, collectionViewLayout, indexPath) -> CGSize in
            return CGSize(width: 100, height: 30)
        })
    }

    func setupLocationListView() {
        locationProxy = MMArrayTableViewProxy(tableView: self.locationListView, identifier: { (tableView, indexPath) -> String in
            return "TouristLocationsLocationCell"
        })
    }
}
