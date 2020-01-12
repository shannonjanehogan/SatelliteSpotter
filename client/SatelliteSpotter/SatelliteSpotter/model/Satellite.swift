//
//  Satellite.swift
//  SatelliteSpotter
//
//  Created by Reginald McDonald  on 2020-01-11.
//  Copyright © 2020 Reginald McDonald . All rights reserved.
//

import Foundation
import SceneKit
import ARKit_CoreLocation

struct GeoCoordinate {
    let lat: Double
    let lon: Double
}

struct Satellite {
    let noradId: Int
    let tle: String?
    let azimuth: Double?
    let elevation: Double?
    let range: Double?
    let height: Double?
    let geoCoord: GeoCoordinate?
    let velocity: Double?
    let name: String?
    let countryOfOrigin: String?
    let satOwner: String?
    let comments: String?
    let launchVehicle: String?
    let dateOfLaunch: String?
    let users: String?
    
    var node: AnnotationNode?
    
    init(
        noradId nId: Int = 0,
        tle: String? = nil,
        azimuth az: Double? = nil,
        elevation ev: Double? = nil,
        range r: Double? = nil,
        height h: Double? = nil,
        geoCoord coord: GeoCoordinate? = nil,
        velocity v: Double? = nil,
        node: AnnotationNode? = nil,
        name: String? = nil,
        countryOfOrigin: String? = nil,
        satOwner: String? = nil,
        comments: String? = nil,
        launchVehicle: String? = nil,
        dateOfLaunch: String? = nil,
        users: String? = nil) {
        
        self.noradId = nId
        self.tle = tle
        self.azimuth = az
        self.elevation = ev
        self.range = r
        self.height = h
        self.geoCoord = coord
        self.velocity = v
        self.node = node
        self.name = name
        self.countryOfOrigin = countryOfOrigin
        self.satOwner = satOwner
        self.comments = comments
        self.launchVehicle = launchVehicle
        self.dateOfLaunch = dateOfLaunch
        self.users = users
    }
    
}
