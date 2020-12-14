//
//  MapViewViewController.swift
//  UserLocation
//
//  Created by Sergey on 12/14/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    let manager = CLLocationManager()
    let regionInMeters: Double = 10_000
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureLocationManager()
    }
    
    private func configureLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }
    }
    
}

//MARK: -

extension MapViewViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            renderViewOnTheMap(location)
        } else if let location = locations.last {
            renderViewOnTheMap(location)
        }
    }
    
    func renderViewOnTheMap(_ location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.addAnnotation(pin)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
//            centerViewOnUserLocation()
//            locationManager.startUpdatingLocation()
        case .denied:
            //Show an alert letting the user know what to do
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            //Show an alert letting the user know what is up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
}
