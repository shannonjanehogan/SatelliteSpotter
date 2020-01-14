//
//  SatelliteService.swift
//  SatelliteSpotter
//
//  Created by Reginald McDonald  on 2020-01-11.
//  Copyright © 2020 Reginald McDonald . All rights reserved.
//

import Foundation


enum NetworkError: Error {
    case badReq
}

struct SatObj: Codable {
    let noradId: Int
    let tle: String
//    let name: String
    let azimuth: Double
    let elevation: Double
    let range: Double
    let height: Double
    let lat: Double
    let lng: Double
    let velocity: Double
    let name: String?
    let countryOfOrigin: String?
    let satOwner: String?
    let comments: String?
    let launchVehicle: String?
    let dateOfLauch: String?
    let users: String?
}
//enum SatObjKey: String, Decodable {
//    case id
////    case name
//    case azimuth
//    case elevation
//    case range
//    case height
//    case lat
//    case lon
//    case velocity
//}

class SatelliteService {
    
    var satellites: [SatObj] = []
    var viewController: ViewController;
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func doRequest(lat: Double, lon: Double) {
        let session = URLSession.shared
        guard let url = URL(string: String(format: "http://35.193.101.67:80/satellites?lat=%f&lon=%f", lat, lon)) else {
            return 
        }
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("There was an error communicating with the server")
                return
            }
            
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            let objs: [SatObj] = try! decoder.decode([SatObj].self, from: data)
            var satellites: [Satellite] = self.toModels(satobjs: objs)
            self.viewController.satellites = satellites
            self.viewController.loadAllSatellites(satellites: satellites)
        })
        
        task.resume()
    }
    
    func toModels(satobjs: [SatObj]) -> [Satellite] {
        var sats: [Satellite] = [];
        for satobj: SatObj in satobjs {
            var s = Satellite(noradId: satobj.noradId,
                              tle: satobj.tle,
                              azimuth: satobj.azimuth,
                              elevation: satobj.elevation,
                              range: satobj.range,
                              height: satobj.height,
                              geoCoord: GeoCoordinate(lat: satobj.lat, lon: satobj.lng),
                              velocity: satobj.velocity,
                              name: satobj.name,
                              countryOfOrigin: satobj.countryOfOrigin,
                              satOwner: satobj.satOwner,
                              comments: satobj.comments,
                              launchVehicle: satobj.launchVehicle,
                              dateOfLaunch: satobj.dateOfLauch,
                              users: satobj.users
            )
            sats.append(s)
        }
        return sats
    }
}
