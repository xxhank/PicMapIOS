//
//  PlantViewController.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/1/31.
//  Copyright (c) 2016年 wangchaojs02. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import MapKit
import SnapKit
import CoreLocation
import XCGLogger
import PKHUD
import FBAnnotationClustering

protocol PlantViewControllerInput: class
{
    func displayLocationInformation(viewModel: ViewModel<LocationViewModel>)
    func displaySightList(viewModel: ViewModel<Plant_SightList_ViewModel>)
    func displaySightDetail(viewModel: ViewModel<Plant_TripList_ViewModel>)
}

protocol PlantViewControllerOutput
{
    func fetchLocationInformation(request: Plant_FormatLocation_Requset)
    func fetchSightList(request: Plant_FetchSightList_Request)
    func fetchSightDetail(request: Plant_FetchSightDetail_Request)
}

class PlantViewController: UIViewController, PlantViewControllerInput
{
    // MARK: - CleanSwift
    var output: PlantViewControllerOutput!
    var router: PlantRouter!

    // MARK: - Outlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sightNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var sightLocationLabel: UILabel!
    @IBOutlet weak var detailPanelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailPanel: UIView!
    @IBOutlet var touristListView: UITableView!

    // MARK: - Location
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000 * 1000 // 默认1000
    var initialLocation = CLLocation(latitude: 39.9, longitude: 116.3)

    // MARK: - Cluster annotations
    var clusteringManager: FBClusteringManager = FBClusteringManager(annotations: [])
    var queue = NSOperationQueue()

    // MARK: - Detail View
    var proxy: MMArrayTableViewProxy?

    // MARK: Object lifecycle
    override func awakeFromNib()
    {
        super.awakeFromNib()
        PlantConfigurator.sharedInstance.configure(self)
    }

    // MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupMapView()
        setupDetailView()
        doSomethingOnLoad()
    }

    // MARK: Event handling
    func doSomethingOnLoad()
    {
        // NOTE: Ask the Interactor to do some work
        // let request = PlantRequest()
    }

    // MARK: Display logic
    func displayLocationInformation(viewModel: ViewModel<LocationViewModel>) {
        switch viewModel {
        case .Result(let result):
            self.cityNameLabel.text = result.city;
            self.sightNameLabel.text = result.location;
            self.sightLocationLabel.text = result.street;
            break;
        case .Error:

            // PKHUD.sharedHUD.contentView = PKHUDTextView(text: error.localizedDescription)
            // PKHUD.sharedHUD.show()
            // PKHUD.sharedHUD.hide(afterDelay: 2.0)
            break;
        }
    }

    func displaySightList(viewModel: ViewModel<Plant_SightList_ViewModel>) {
        switch viewModel {
        case .Error(let error):
            PKHUD.sharedHUD.contentView = PKHUDTextView(text: error.localizedDescription)
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 2.0)
            break;
        case .Result(let result):
            let annotations = result.sightList.map({ (viewModel) -> SightAnnotation in
                return SightAnnotation(viewModel: viewModel) ;
            })

            self.clusteringManager.addAnnotations(annotations)
            self.addAnnotations(onMapView: self.mapView)
            break;
        }
    }

    func displaySightDetail(viewModel: ViewModel<Plant_TripList_ViewModel>) {
        switch viewModel {
        case .Error(let error):
            PKHUD.sharedHUD.contentView = PKHUDTextView(text: error.localizedDescription)
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 2.0)
            break
        case .Result(let result):
            proxy?.datas = result.trips

            let MapViewPanelHeight: CGFloat = 200;
            let ViewPadding: CGFloat = 64 + 49;
            let detailPanelHeight = CGRectGetHeight(self.view.bounds) - ViewPadding - MapViewPanelHeight;

            if self.detailPanelHeightConstraint.constant != detailPanelHeight {
                self.view.userInteractionEnabled = false;

                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.detailPanelHeightConstraint.constant = detailPanelHeight;
                    self.view.layoutIfNeeded() ;
                }, completion: { (finished) -> Void in
                    self.view.userInteractionEnabled = true;
                })
            }

            break
        }
    }

    // MARK: - Action
    @IBAction func centerMe() {
        self.centerMapOnLocation(initialLocation, regionRadius: self.regionRadius)
    }
}

// MARK: - Location
extension PlantViewController: MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: - Help Method
    func setupMapView()
    {
        checkLocationAuthorizationStatus()

        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.distanceFilter = CLLocationDistance(1000)

        self.mapView.delegate = self

        self.centerMapOnLocation(initialLocation, regionRadius: self.regionRadius)
    }

    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true;
        } else {
            locationManager.requestWhenInUseAuthorization() ;
            mapView.showsUserLocation = true;
        }
    }

    func centerMapOnLocation(location: CLLocation, regionRadius : CLLocationDistance)
    {
        let corrdinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(corrdinateRegion, animated: true)
    }

    func addAnnotations(onMapView mapView: MKMapView)
    {
        self.queue.cancelAllOperations()
        self.queue.addOperationWithBlock { () -> Void in
            let width = Double(mapView.bounds.size.width)
            let visibleWidth = mapView.visibleMapRect.size.width
            let scale = width / visibleWidth
            let annotations = self.clusteringManager.clusteredAnnotationsWithinMapRect(mapView.visibleMapRect, withZoomScale: scale)
            self.clusteringManager.displayAnnotations(annotations, onMapView: mapView)
        }
    }
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = locations.last!;
        self.mapView.region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, regionRadius, regionRadius) ;
        self.locationManager.stopUpdatingLocation() ;
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }

    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = NSStringFromClass(annotation.dynamicType)
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? SightAnnotationView
        if annotationView == nil {
            annotationView = SightAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView?.annotation = annotation
        }

        annotationView?.update()

        return annotationView
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)

        if let annotation = view.annotation as? SightAnnotation {
            self.output.fetchSightDetail(Plant_FetchSightDetail_Request(trips: annotation.viewModel.trips))
        }
    }
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        if self.scrollView != nil {
//            UIView.animateWithDuration(0.5) { () -> Void in
//                if self.pinView != nil {
//                    self.pinView.pinSelected = false
//                }
//
//                self.scrollView.transform = CGAffineTransformIdentity
//            }
//        }
    }
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerLocation = CLLocation(latitude: mapView.centerCoordinate.latitude,
            longitude: mapView.centerCoordinate.longitude)
        output.fetchLocationInformation(Plant_FormatLocation_Requset(location: centerLocation))
        self.addAnnotations(onMapView: self.mapView)
    }

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        self.initialLocation = userLocation.location!
        /**
         * 根据地理位置,解析出城市名称
         */
        // output.fetchLocationInformation(Plant_FormatLocation_Requset(location: userLocation.location!))
        output.fetchSightList(Plant_FetchSightList_Request(region: mapView.region))
    }
}

// MARK: - DetailView
extension PlantViewController
{
    func setupDetailView() {
        self.detailPanel.addSubview(self.touristListView) ;
        self.touristListView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.detailPanel)
        }

        proxy = MMArrayTableViewProxy(tableView: self.touristListView, identifier: { (tableView, indexPath) -> String in
            return "TouristLatestCell"
        }, builder: { (tableView, indexPath, identifier) -> UITableViewCell? in
            return nil;
        }, modifier: { (tableView, cell, data) -> () in

            if let tripCell = cell as? PlantTripCell {
                tripCell.viewModel = data as? TripCellViewModel;
            }
        })

        proxy?.selectSignal.observeNext({ (indexPath, viewModel) -> () in
            if let viewModel = viewModel as? TripCellViewModel {
                self.router.showTripDetail(viewModel.tripID)
            }
        })
    }
}
