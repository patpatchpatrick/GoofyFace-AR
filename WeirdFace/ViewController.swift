//
//  ViewController.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 6/26/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {
    

    @IBOutlet weak var sceneView: ARSCNView!
    
    var contentNode: SCNNode?
    var tattooWidth: CGFloat = 1000.0
    var tattooHeight: CGFloat = 1000.0
    var tattooX: CGFloat = 0.0
    var tattooY: CGFloat = 0.0
    var imageChanged = false
    var primaryImage: UIImage?
    var resizedImg: UIImage?
    var imageOnCanvas: UIImage?
    var contentImage: UIImage?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        
        primaryImage = UIImage(named: "noragrets")
        
        sceneView.delegate = self
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
    
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        if tattooHeight < 900.0 {
            tattooWidth += 100.0
            tattooHeight += 100.0
            checkPositions()
              imageChanged = true
        }
        
    }
    
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        if tattooHeight > 200.0 {
            tattooWidth -= 100.0
            tattooHeight -= 100.0
            checkPositions()
              imageChanged = true
        }
    }
    
    
    @IBAction func plusX(_ sender: UIButton) {
        
        tattooX += 100.0
        if tattooX > (1000 - tattooWidth) {
            tattooX = 1000 - tattooWidth
        }
        imageChanged = true
        
    }
    
    
    @IBAction func plusY(_ sender: UIButton) {
        
        tattooY += 100.0
        if tattooY > (1000 - tattooHeight) {
            tattooY = 1000 - tattooHeight
        }
        imageChanged = true
        
    }
    
    
    @IBAction func minusX(_ sender: UIButton) {
        
        tattooX -= 100.0
        if tattooX < 0 {
            tattooX = 0
        }
         imageChanged = true
        
    }
    
    @IBAction func minusY(_ sender: UIButton) {
        
        tattooY -= 100.0
        if tattooY < 0 {
            tattooY = 0
        }
     imageChanged = true
        
    }
    
    func checkPositions(){
        
        if tattooY > (1000 - tattooHeight) {
            tattooY = 1000 - tattooHeight
            imageChanged = true
        }
        if tattooX > (1000 - tattooWidth) {
            tattooX = 1000 - tattooWidth
            imageChanged = true
        }
        
    }
    
    

}

extension ViewController: ARSCNViewDelegate {
    // 2
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let sceneView = renderer as? ARSCNView,
            anchor is ARFaceAnchor else { return nil }
        
        #if targetEnvironment(simulator)
        #error("ARKit is not supported in iOS Simulator. Connect a physical iOS device and select it as your Xcode run destination, or select Generic iOS Device as a build-only destination.")
        #else
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
        let material = faceGeometry.firstMaterial!
        
        
            
             let resizedImg = resizeImage(image: primaryImage!, targetSize: CGSize(width: tattooWidth, height: tattooHeight))
            
            let expandedSize = CGSize(width: 1000, height: 1000)
            
            imageOnCanvas = drawImageOnCanvas(resizedImg, canvasSize: expandedSize, canvasColor: .clear, x:tattooX, y: tattooY)
            
            contentImage = imageOnCanvas
            
            material.diffuse.contents = contentImage// Example texture map image.
            material.lightingModel = .physicallyBased
            
        
        
        
        contentNode = SCNNode(geometry: faceGeometry)
        #endif
        return contentNode
        
        
    }
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {

        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        
        if imageChanged {
            
            let material = faceGeometry.firstMaterial!
                
                resizedImg = resizeImage(image: primaryImage!, targetSize: CGSize(width: tattooWidth, height: tattooHeight))
                
                let expandedSize = CGSize(width: 1000, height: 1000)
                
                imageOnCanvas = drawImageOnCanvas(resizedImg!, canvasSize: expandedSize, canvasColor: .clear, x: tattooX, y: tattooY)
                
                contentImage = imageOnCanvas
                
                material.diffuse.contents = contentImage!// Example texture map image.
                material.lightingModel = .physicallyBased
                
            
            imageChanged = false
        }

        
        faceGeometry.update(from: faceAnchor.geometry)
 
    }
    
}


