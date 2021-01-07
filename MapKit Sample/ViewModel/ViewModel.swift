//
//  viewModel.swift
//  MapKit Sample
//
//  Created by Athlosn90 on 29/12/2020.
//  Copyright © 2020 Athlosn90. All rights reserved.
//

import Foundation

class ViewModel {
    
    private var locationManager = LocationManager()

  
    func startLocation() {

        locationManager.initLocation()
        
    }
    
}
