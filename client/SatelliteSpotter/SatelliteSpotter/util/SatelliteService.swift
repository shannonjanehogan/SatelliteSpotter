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
//    let name: String
    let azimuth: Double
    let elevation: Double
    let range: Double
    let height: Double
    let lat: Double
    let lng: Double
    let velocity: Double
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
    
    var satellites: [Any] = []
    
    func doRequest() {
        let session = URLSession.shared
        guard let url = URL(string: "http://dhcp-206-87-194-53.ubcsecure.wireless.ubc.ca:3000/") else {
            return 
        }
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            let objs = try! decoder.decode([SatObj].self, from: data)
            self.satellites = objs
        })
        
        task.resume()
    }
    
    func toModels() -> [Satellite] {
        
    }
}
