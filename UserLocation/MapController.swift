//
//  ViewController.swift
//  UserLocation
//
//  Created by Sergey on 12/13/20.
//

import UIKit
import MapKit
import CoreLocation

final class MapController: UIViewController {

    //MARK: - Views that will be displayed on this controller
    @IBOutlet weak var map: MKMapView!
    
    //MARK: - Constants and Variables
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        checkLocationServices()
    }
    
    ///Configures Initial UI
    func setInitialUI() {
        //Background color of the main view
        view.backgroundColor = .systemBackground
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
        } else {
            //Show an alert to let the user know the must to turn in on
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
        }
    }
    
}

//MARK: - CLLocationManagerDelegate Implementation

extension MapController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        map.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            //Show an alert letting the user know what to do
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
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
