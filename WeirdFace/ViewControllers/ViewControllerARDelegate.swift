//
//  ViewControllerARDelegate.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/22/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import SceneKit
import ARKit



extension ViewController: ARSCNViewDelegate {
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        //New node added to AR renderer
        if !arTrackingSupported {return nil}
        
        guard let sceneView = renderer as? ARSCNView, let frame = sceneView.session.currentFrame,
            anchor is ARFaceAnchor else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!, fillMesh: true)!
        
        
        let material = faceGeometry.firstMaterial!
        
        func renderTattooImage(){
            
            //If the image was changed, set the new image on the face contents
            if tattooViewModel!.imageChanged {
                material.diffuse.contents = tattooViewModel?.image
                material.lightingModel = .physicallyBased
                
                tattooViewModel?.imageChanged = false
                
            }
        }
        
        func renderDistortedFace(){
            
            material.diffuse.contents = sceneView.scene.background.contents
            material.lightingModel = .constant
            
            guard let shaderURL = Bundle.main.url(forResource: "FaceDistortion", withExtension: "shader"),
                let modifier = try? String(contentsOf: shaderURL)
                else { fatalError("Can't load shader modifier from bundle.") }
            faceGeometry.shaderModifiers = [ .geometry: modifier]
            
            // Pass view-appropriate image transform to the shader modifier so
            // that the mapped video lines up correctly with the background video.
            let affineTransform = frame.displayTransform(for: .portrait, viewportSize: sceneView.bounds.size)
            let transform = SCNMatrix4(affineTransform)
            faceGeometry.setValue(SCNMatrix4Invert(transform), forKey: "displayTransform")
            faceGeometry.setValue(distortionViewModel?.headDistortion, forKey: "headSize")
            faceGeometry.setValue(distortionViewModel?.eyeDistortion, forKey: "eyeSize")
            faceGeometry.setValue(distortionViewModel?.noseDistortion, forKey: "noseSize")
            faceGeometry.setValue(distortionViewModel?.mouthDistortion, forKey: "mouthSize")
            faceGeometry.setValue(distortionViewModel?.headCurrentXPosition, forKey: "xPos")
            faceGeometry.setValue(distortionViewModel?.headCurrentYPosition, forKey: "yPos")
            faceGeometry.setValue(distortionViewModel?.headCurrentZPosition, forKey: "zPos")
            
            
        }
        
        //Render appropriate image based on mode selected
        switch mainUIViewModel?.appMode {
        case modeTattoo: renderTattooImage()
            break
        case modeFaceDistortion: renderDistortedFace()
            break
        case .none:
            print("none")
        case .some(_):
            print("some")
        }
        
        return SCNNode(geometry: faceGeometry)
        
    }
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {
        
        if !arTrackingSupported {return}
        
        
        //Renderer node updated
        
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor, let frame = sceneView.session.currentFrame
            else { return }
        
        var material = faceGeometry.firstMaterial!
        
        func renderTattooImage(){
            
            //If the app mode changed back to tattoo mode, clear face geometry modifiers
            if mainUIViewModel!.appModeChanged {
                print("App Mode Changed")
                material.diffuse.contents = tattooViewModel?.image
                material.lightingModel = .physicallyBased
                faceGeometry.shaderModifiers = [ .geometry: ""]
                faceGeometry.setValue("", forKey: "displayTransform")
                mainUIViewModel!.appModeChanged = false
            }
            
            //If the image was changed, set the new image on the face contents
            if tattooViewModel!.imageChanged {
                material.diffuse.contents = tattooViewModel?.image
                material.lightingModel = .physicallyBased
                tattooViewModel?.imageChanged = false
                
            }
            
        }
        
        func renderDistortedFace(){
            
            material.diffuse.contents = sceneView.scene.background.contents
            material.lightingModel = .constant
            
            guard let shaderURL = Bundle.main.url(forResource: "FaceDistortion", withExtension: "shader"),
                let modifier = try? String(contentsOf: shaderURL)
                else { fatalError("Can't load shader modifier from bundle.") }
            faceGeometry.shaderModifiers = [ .geometry: modifier]
            
            // Pass view-appropriate image transform to the shader modifier so
            // that the mapped video lines up correctly with the background video.
            let affineTransform = frame.displayTransform(for: .portrait, viewportSize: sceneView.bounds.size)
            let transform = SCNMatrix4(affineTransform)
            faceGeometry.setValue(SCNMatrix4Invert(transform), forKey: "displayTransform")
            faceGeometry.setValue(distortionViewModel?.headDistortion, forKey: "headSize")
            faceGeometry.setValue(distortionViewModel?.eyeDistortion, forKey: "eyeSize")
            faceGeometry.setValue(distortionViewModel?.noseDistortion, forKey: "noseSize")
            faceGeometry.setValue(distortionViewModel?.mouthDistortion, forKey: "mouthSize")
            faceGeometry.setValue(distortionViewModel?.headCurrentXPosition, forKey: "xPos")
             faceGeometry.setValue(distortionViewModel?.headCurrentYPosition, forKey: "yPos")
             faceGeometry.setValue(distortionViewModel?.headCurrentZPosition, forKey: "zPos")
            
        }
        
        
        //Render appropriate image based on mode selected
        switch mainUIViewModel?.appMode {
        case modeTattoo: renderTattooImage()
        print("Tattoo")
            break
        case modeFaceDistortion: renderDistortedFace()
        print("Distorted")
            break
        case .none:
            print("none")
        case .some(_):
            print("some")
        }
        
        
        faceGeometry.update(from: faceAnchor.geometry)
        
    }
    
    
    
    
    
    
}

