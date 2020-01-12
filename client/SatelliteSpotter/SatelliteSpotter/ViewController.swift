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
import CoreLocation

struct ARCoordinate {
    let x: Float
    let y: Float
    let z: Float
    
    var toVector: SCNVector3 {
        return SCNVector3(x, y, z)
    }
}

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var satellites: [ Satellite ] = []
    var service: SatelliteService = SatelliteService()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        
        let scene = SCNScene();
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ ARSCNDebugOptions.showFeaturePoints ]
        for _ in 1...10 {
            let x = Float.random(in: -1...1)
            let y = Float.random(in: 0...1)
            let z = Float(-0.344)
            addSatellite(atCoordinates: ARCoordinate(x: x, y: y, z: z))
        }
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationBrain.shared.start(delegate: self)
        service.doRequest()
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
    
    private func addSatellite(atCoordinates coordinates: ARCoordinate) {
        let scene = SCNScene(named: "art.scnassets/satellite.scn")!
        let satelliteNode = scene.rootNode.childNode(withName: "plane", recursively: false)
        satelliteNode?.position = coordinates.toVector
        satelliteNode?.scale = .init(0.05, 0.05, 0.05)
        guard let node = satelliteNode else { assertionFailure(); return }
        let sat = Satellite(noradId: 0,node: node)
        self.sceneView.scene.rootNode.addChildNode(node)
        self.satellites.append(sat)
        
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
}

extension ViewController : LocationBrainDelegate {
    func locationWasFound(location: CLLocation) {
        
    }
}
