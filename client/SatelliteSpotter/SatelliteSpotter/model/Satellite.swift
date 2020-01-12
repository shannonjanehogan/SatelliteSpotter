//
//  Satellite.swift
//  SatelliteSpotter
//
//  Created by Reginald McDonald  on 2020-01-11.
//  Copyright © 2020 Reginald McDonald . All rights reserved.
//

import Foundation
import SceneKit

struct GeoCoordinate {
    let lat: Double
    let lon: Double
}

struct Satellite {
    let noradId: Int
    let azimuth: Double?
    let elevation: Double?
    let range: Double?
    let height: Double?
    let geoCoord: GeoCoordinate?
    let velocity: Double?
    
    let node: SCNNode
    
    init(
        noradId nId: Int = 0,
        azimuth az: Double? = nil,
        elevation ev: Double? = nil,
        range r: Double? = nil,
        height h: Double? = nil,
        geoCoord coord: GeoCoordinate? = nil,
        velocity v: Double? = nil,
        node: SCNNode) {
        
        self.noradId = nId
        self.azimuth = az
        self.elevation = ev
        self.range = r
        self.height = h
        self.geoCoord = coord
        self.velocity = v
        self.node = node
    }
    
}
