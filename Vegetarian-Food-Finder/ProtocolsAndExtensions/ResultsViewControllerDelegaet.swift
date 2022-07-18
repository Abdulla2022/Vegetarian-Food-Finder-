//
//  ResultsViewControllerDelegaet.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/18/22.
//

import UIKit
import CoreLocation
import MapKit

protocol ResultsViewControllerDelegaet: AnyObject {
    func didTapPlace(with coordinate: CLLocationCoordinate2D)
}
extension MapViewController : ResultsViewControllerDelegaet {
    func didTapPlace(with coordinate: CLLocationCoordinate2D){
        searchVC.searchBar.resignFirstResponder()
        let annotations = MKMapView.annotations
        MKMapView.removeAnnotations(annotations)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        MKMapView.addAnnotation(pin)
        MKMapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
    }
}
