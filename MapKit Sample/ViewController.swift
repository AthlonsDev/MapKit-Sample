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

    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    
//    Initializers for Location

    var sourceCoordinate: CLLocationCoordinate2D?
    var selectedCoord = CLLocationCoordinate2D()
    let items = ["Walking", "Driving"]
    var transportType: String = "Walking"

  
    var viewModel = ViewModel()

    func initLocation() {
        
        mapView.showsUserLocation = true
        mapView.pointOfInterestFilter = .includingAll
        mapView.showsScale = true
        
        guard let coordinates = sourceCoordinate else {return}

        let viewRegion = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: true)
        
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

        addSearchBar()
        
//        Get Location
        viewModel.startLocation()
        
        

    }

    @IBAction func navSwitch(_ sender: Any) {
        
        switch segmentView.selectedSegmentIndex {
               case 0:

                   transportType = "Walking"
                   getDirections(toAnnotation: selectedCoord, transport: "Walking")
                   
               case 1:
                   
                   transportType = "Driving"
                   getDirections(toAnnotation: selectedCoord, transport: "Driving")

               default:
                   break
               }
        
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
            self.selectedCoord = myCoordinates
            self.getDirections(toAnnotation: myCoordinates, transport: self.transportType)
            }
        }
    
    }
    
    func getDirections(toAnnotation: CLLocationCoordinate2D, transport: String) {
            //      Get Directions To Selecetd Place
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.sourceCoordinate!))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: toAnnotation))
            request.requestsAlternateRoutes = true
     
            //            Show Selected Transport Type
            if transport == "Walking" {
                request.transportType = .walking

            } else if transport == "Driving" {
                request.transportType = .automobile
                
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


extension ViewController: locationProtocol {
    func shareLocation(permission: Bool, location: CLLocationCoordinate2D) {
        if permission == true {
            print(permission)
            sourceCoordinate = location
            initLocation()
        }
    }
    
    
}
