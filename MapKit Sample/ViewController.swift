//
//  ViewController.swift
//  MapKit Sample
//
//  Created by Athlosn90 on 09/07/2020.
//  Copyright © 2020 Athlosn90. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController:  UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    
//    Initializers for Location
    var locationManager = CLLocationManager()
    var currentLocation:CLLocation?
    var sourceCoordinate: CLLocationCoordinate2D?
    var selectedCoord = CLLocationCoordinate2D()
    
    lazy var mapView: MKMapView = {
        var mv = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        mv.delegate = self
        
        return mv
    }()
    
    
    
    func initLocation() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.pointOfInterestFilter = .includingAll
        mapView.showsScale = true
        
        
        sourceCoordinate = locationManager.location?.coordinate
        

//        let viewRegion = MKCoordinateRegion.init(center: sourceCoordinate!, latitudinalMeters: 200, longitudinalMeters: 200)
//        mapView.setRegion(viewRegion, animated: true)
        
    }
    
    func addSearchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.autocapitalizationType = .words
        searchBar.autocorrectionType = .default
        searchBar.barStyle = .default
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Search by Address or Location"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)

        
        addSearchBar()
        initLocation()

    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchItem  = searchBar.text else {return}
        
        findAddress(address: searchItem)
    }
    
    func findAddress(address: String) {
        let geoCode = CLGeocoder()
        geoCode.geocodeAddressString(address) { (placeMark, error) in
        
        if error != nil {
            print(error?.localizedDescription)
        } else {
            print(placeMark)
            
            let postLocation = placeMark?.first?.location
            guard let myCoordinates = postLocation?.coordinate else {return}

            
            //        Add Pin/Placemark
                let annotation = MKPointAnnotation()
                        annotation.coordinate = myCoordinates
            //            annotation.title = self.myTitle
                self.mapView.addAnnotation(annotation)
            
                getDirections(toAnnotation: myCoordinates)
            }
        }
    
    }
    
       func getDirections(toAnnotation: CLLocationCoordinate2D) {
            //      Get Directions To Selecetd Place
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.sourceCoordinate!))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: toAnnotation))
            request.requestsAlternateRoutes = true
     
            //            Show Selected Transport Type
            if walking == true {
                request.transportType = .walking
                
            } else if driving == true {
                request.transportType = .automobile
                
            } else if publicTransport == true {
                request.transportType = .transit
                
            }
            
            let directions = MKDirections(request: request)
            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                for route in unwrappedResponse.routes {
                    let directionPath = route.polyline
                    self.mapView.removeOverlay(directionPath)
                    self.mapView.addOverlay(directionPath)
                    self.mapView.setVisibleMapRect(directionPath.boundingMapRect, animated: true)
                    
                    
                    let seconds = Int(route.expectedTravelTime)
                    let minutes = seconds / 60
                    let hours = seconds / 3600
                    let days = hours / 24
                    
                    print(minutes)
                    print(minutes.remainderReportingOverflow(dividingBy: 60))
                    
    //                let weeks = 7 / days
    //                let months = 4 / weeks
    //                let years = 12 / months
                    
                    if minutes > 0 && hours < 1 && days < 1 {
                        return self.timeLbl.text = ("Time Expected: \(minutes) Minutes")
                    }
                    if minutes > 0 && hours > 0 && days < 1 {
                        return self.timeLbl.text = ("Time Expected: \(hours) Hours and \(minutes % 60) Minutes")
                    }
                    if minutes > 0 && hours > 0 && days > 0 {
                        return self.timeLbl.text = ("Time Expected: \(days) Days,  \(hours % 24) Hours and \(minutes % 60) Minutes")
                    }
                    
                }
            }
        }

}

