//
//  SatelliteUtils.swift
//  SatelliteSpotter
//
//  Created by Reginald McDonald  on 2020-01-11.
//  Copyright © 2020 Reginald McDonald . All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationBrainDelegate: class {
    func locationWasFound(location: CLLocation)
}

class LocationBrain: NSObject, CLLocationManagerDelegate {
    static let shared = LocationBrain()
    private let locationManager: CLLocationManager
    private var lastLocation: CLLocation?
    private weak var delegate: LocationBrainDelegate?
    
    private override init() {
        self.locationManager = CLLocationManager()
        super.init()
    }
    
    func start(delegate: LocationBrainDelegate) {
        // start location tracking
        self.delegate = delegate
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = 500.0
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            NSLog("No location")
            return
        }
        self.lastLocation = location
        NSLog("Got location: \(location)")
        self.delegate?.locationWasFound(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog(error.localizedDescription)
    }
}


