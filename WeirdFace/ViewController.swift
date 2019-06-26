//
//  ViewController.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 6/26/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    
    @IBOutlet var sceneView: ARSCNView!
    
    var noseNode: BodyPartNode?
    var capturedFrameImage: UIImage?
    var num = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        
        sceneView.delegate = self
        sceneView.session.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.pause()
    }
    
    func updateFeatures(for node: SCNNode, using anchor: ARFaceAnchor) {
        // 1
        
        if let pix = capturedFrameImage {
         noseNode?.image = pix
        }
        
        let child = node.childNode(withName: "nose", recursively: false) as? BodyPartNode
        child?.plane?.firstMaterial?.diffuse.contents = child?.image
     
        let vertices = [anchor.geometry.vertices[9]]
        
        child?.updatePosition(for: vertices)
    }

    


}

extension ViewController: ARSCNViewDelegate {
    // 2
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let device = sceneView.device else {
                return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        
        let node = SCNNode(geometry: faceGeometry)
        
        node.geometry?.firstMaterial?.fillMode = .lines
        
        node.geometry?.firstMaterial?.transparency = 0.0
        
        noseNode = BodyPartNode()
        
        noseNode?.name = "nose"
        
        if let bodyPartNode = noseNode {
            node.addChildNode(bodyPartNode)
        }
        
        updateFeatures(for: node, using: faceAnchor)
        
        return node
    }
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {

        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
        
        updateFeatures(for: node, using: faceAnchor)
    }
    
}

extension ViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        capturedFrameImage = UIImage(pixelBuffer: frame.capturedImage)
    }
    
    
}

