//
//  MapViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/17/22.
//

import CoreLocation
import MapKit
import UIKit
class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchResultsUpdating {
    var regionInMeters: Double = 1000
    var locationManger = CLLocationManager()
    @IBOutlet var MKMapView: MKMapView!
    let searchVC = UISearchController(searchResultsController: ResultsViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.enablesReturnKeyAutomatically = false
        searchVC.searchBar.placeholder = "Maps"
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }

    func setUpLocationManger() {
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManger()
            MKMapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManger.startUpdatingLocation()
        } else {
            showOkActionAlert(withTitle: "Can't get the location of the user", andMessage: "Location services are disabled")
        }
    }

    func centerViewOnUserLocation() {
        if let location = locationManger.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            MKMapView.setRegion(region, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        MKMapView.setRegion(region, animated: true)
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty, let resultVC = searchController.searchResultsController as? ResultsViewController else {
            return
        }
        resultVC.delegaet = self
        GooglePlacesApi.shared.findPlaces(query: query) { result in
            switch result {
            case let .success(places):
                DispatchQueue.main.sync {
                    resultVC.update(with: places)
                }
            case let .failure(_):
                self.showOkActionAlert(withTitle: "Google API faild", andMessage: "try again later")
            }
        }
    }
}
