//
//  ARDistortionViewModel.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/22/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation

class ARDistortionViewModel : ARDistortionViewModelProtocol{
    
    var model: ARDistortionModel
    var viewDelegate: ARDistortionViewModelViewDelegate
    var currentFeature:Int = 0 //Current feature being edited
    var eyeDistortion: Float = 1.0 //Magnitude of eye distortion
    var noseDistortion: Float = 1.0 //Magnitude of nose distortion
    
    init(model: ARDistortionModel, delegate: ARDistortionViewModelViewDelegate ) {
        self.model = model
        self.viewDelegate = delegate
    }
    
    func setCurrentFeatureBeingEdited(feature: Int){
        currentFeature = feature
    }
    
    func featureSliderValueUpdated(value: Float){
        //Update the values of facial features distortion dependning on which feature is being edited
        switch currentFeature{
        case featureEyes: eyeDistortion = value
        case featureNose: noseDistortion = value
        default: print("Default")
        }
    }
    
}


