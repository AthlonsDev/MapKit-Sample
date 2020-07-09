//
//  View.swift
//  MapKit Sample
//
//  Created by Athlosn90 on 09/07/2020.
//  Copyright © 2020 Athlosn90. All rights reserved.
//

import Foundation
import UIKit

class View: UIView {
    
    var vc: ViewController?
    
    
    var timeLbl: UILabel = {
        var timeLbl = UILabel()
        timeLbl.font = UIFont.systemFont(ofSize: 16)
        timeLbl.textAlignment = .center
        timeLbl.textColor = UIColor.black
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        timeLbl.text = "Calculating..."
        return timeLbl
    }()

    var segmentView: UISegmentedControl = {
       var sv = UISegmentedControl()
        sv.selectedSegmentIndex = 0
        sv.tintColor = UIColor(displayP3Red: 0/255, green: 144/255, blue: 7/255, alpha: 1)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.cornerRadius = 5
        return sv
    }()
    
    func addUI(view: UIView) {
        view.addSubview(timeLbl)
        view.addSubview(segmentView)
        
        
        let timeLabelConstraints = [timeLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                    timeLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        
        let segmentConstraints = [segmentView.bottomAnchor.constraint(equalTo: timeLbl.topAnchor, constant: 30),
                                  segmentView.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
    }
}
