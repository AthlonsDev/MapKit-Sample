//
//  LocationManager.swift
//  MapKit Sample
//
//  Created by Athlosn90 on 29/12/2020.
//  Copyright © 2020 Athlosn90. All rights reserved.
//

import Foundation
import CoreLocation

protocol locationProtocol {
    func shareLocation(permission: Bool, location: CLLocationCoordinate2D)
}

class LocationManager: CLLocationManager, CLLocationManagerDelegate {

    var locationDelegate: locationProtocol!

    
    func initLocation() {
        
        let locationManager = CLLocationManager()
        let currentLocation:CLLocation?
        var sourceCoordinate = CLLocationCoordinate2D()
        let selectedCoord = CLLocationCoordinate2D()

        let auth = CLLocationManager.authorizationStatus()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        
        
        switch auth {
        case .restricted, .denied:
            locationDelegate.shareLocation(permission: false, location: sourceCoordinate)
        default:
            locationManager.startUpdatingLocation()
            sourceCoordinate = locationManager.location!.coordinate
            locationDelegate.shareLocation(permission: true, location: sourceCoordinate)
        }
        
    }
    
}


