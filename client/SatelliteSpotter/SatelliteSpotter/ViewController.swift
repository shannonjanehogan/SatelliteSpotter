//
//  ViewController.swift
//  SatelliteSpotter
//
//  Created by Reginald McDonald  on 2020-01-11.
//  Copyright © 2020 Reginald McDonald . All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ARKit_CoreLocation
import CoreLocation




struct ARCoordinate {
    let x: Float
    let y: Float
    let z: Float
    
    var toVector: SCNVector3 {
        return SCNVector3(x, y, z)
    }
}

class ViewController: UIViewController, ARSCNViewDelegate, LNTouchDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var satellites: [ Satellite ] = []
    var service: SatelliteService?
    var sceneLocationView = SceneLocationView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set the view's delegate
        sceneView.delegate = self
        self.sceneLocationView.locationNodeTouchDelegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        
        
        let scene = SCNScene();
        
        // Set the scene to the view
        sceneView.scene = scene
//        sceneView.showsStatistics = true
//        sceneView.debugOptions = [ ARSCNDebugOptions.showFeaturePoints ]
        service = SatelliteService(viewController: self)
//        for _ in 1...10 {
//            let x = Float.random(in: -1...1)
//            let y = Float.random(in: 0...1)
//            let z = Float(-0.344)
//            addSatellite(atCoordinates: ARCoordinate(x: x, y: y, z: z))
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      sceneLocationView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
//        let node = SCNode();

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
//        sceneLocationView.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationBrain.shared.start(delegate: self)
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
//        loadAllSatellites()
        
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func loadAllSatellites(satellites: [Satellite]) {
//        service.doRequest(lat: self.lat, lon: self.lon)
        self.satellites = satellites
//        print(satellites)
        for var satellite in self.satellites {
            addSatelliteToARView(satellite: &satellite)
        }
    }
    
    private func addSatelliteToARView(satellite: inout Satellite) {
        let scene = SCNScene(named: "art.scnassets/satellite.scn")!
        let satelliteNode = scene.rootNode.childNode(withName: "plane", recursively: false)
        let geocoord = satellite.geoCoord!
        let coordinate = CLLocationCoordinate2D(latitude: geocoord.lat, longitude: geocoord.lon)
        let location = CLLocation(coordinate: coordinate, altitude: satellite.elevation! * 1000)
        let image = UIImage(named: "satellite.png")!
        let annotationNode: LocationAnnotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.annotationNode.name = String(satellite.noradId)
        satellite.node = annotationNode.annotationNode
        
//        satellite.node = annotationNode;
//        annotationNode.scaleRelativeToDistance = true
        
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if (touch.view == self.sceneView) {
            let viewTouchLocation:CGPoint = touch.location(in: sceneView);
            guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {
                return
            }
            for satellite in satellites {
                print("trying")
                if satellite.node == result.node {
                    print ("matched")
                    self.performSegue(withIdentifier: "openDetails", sender: self)
                }
            }
        }
    }
    
    func locationNodeTouched(node: LocationNode) {
        // No location nodes
    }
    
    func annotationNodeTouched(node: AnnotationNode) {
        
        guard let selected = satellites.first(where: {String($0.noradId) == node.name}) else {
            return
        }
        self.performSegue(withIdentifier: "openDetails", sender: selected)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("in prepare")
        if segue.identifier == "openDetails" {
            print("here is controller")
            print(segue.destination)
            print("end")
            if let navController = segue.destination as? UINavigationController {
                if let detailViewController = navController.topViewController as? DetailsTableViewController {
                    print("here")
                    if let satellite = sender as? Satellite {
                        print("In satellite")
                        detailViewController.satellite = satellite
                    }
                }
            }
        }
    }
}

extension ViewController : LocationBrainDelegate {
    func locationWasFound(location: CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        if (satellites.count == 0) {
            guard let service = self.service else {
                return
            }
            service.doRequest(lat: lat, lon: lon)
        }
    }
}
