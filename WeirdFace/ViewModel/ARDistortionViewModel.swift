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
    
    var currentEditMode:Int = 0 //Current facial edit mode
    var currentAttribute:Int = 0 //Current feature being edited
    
    var headDistortion: Float = 1.0 //Magnitude of eye distortion
    var eyeDistortion: Float = 1.0 //Magnitude of eye distortion
    var noseDistortion: Float = 1.0 //Magnitude of nose distortion
    var mouthDistortion: Float = 1.0 //Magnitude of nose distortion
    
    var headCurrentXPosition: Float = 0.0 //Magnitude of position
    var headCurrentYPosition: Float = 0.0 //Magnitude of position
    var headCurrentZPosition: Float = 0.0 //Magnitude of position
    
    init(model: ARDistortionModel, delegate: ARDistortionViewModelViewDelegate ) {
        self.model = model
        self.viewDelegate = delegate
    }
    
    func distortionEditModeChanged(editMode: Int){
        //Set up the views depending on the type of distortion edit mode that the user selected
        currentEditMode = editMode
        switch editMode {
        case facialSizeMode:
            viewDelegate.toggleSecondaryMenu(hidden: false)
            viewDelegate.toggleSecondarySizeSubMenu(hidden: false)
            viewDelegate.toggleSecondaryPositionSubMenu(hidden: true)
          
        case facialPositionMode:
            viewDelegate.toggleSecondaryMenu(hidden: false)
            viewDelegate.toggleSecondarySizeSubMenu(hidden: true)
            viewDelegate.toggleSecondaryPositionSubMenu(hidden: false)
        default:
            print("Default")
        }
        
    }
    
    func hideAllSubMenus(){
        
        viewDelegate.toggleSecondaryMenu(hidden: true)
        viewDelegate.toggleSecondarySizeSubMenu(hidden: true)
        viewDelegate.toggleSecondaryPositionSubMenu(hidden: true)
        
    }
    
    func setCurrentFeatureBeingEdited(feature: Int){
        currentAttribute = feature
    }
    
    func featureSliderValueUpdated(value: Float){
        //Update the values of facial features distortion dependning on which feature is being edited
        switch currentEditMode {
        case facialSizeMode:
            updateFacialSizeValues(value: value)
        case facialPositionMode:
            updateFacialPositionValues(value: value)
        default:
            print("Default")
        }
        
    }
    
    func updateFacialSizeValues(value: Float){
        print("UPDATE FACIAL SIZE")
        switch currentAttribute{
        case featureHead: headDistortion = value
        case featureEyes: eyeDistortion = value
        case featureNose: noseDistortion = value
        case featureMouth: mouthDistortion = value
        default: print("Default")
        }
        
    }
    
    func updateFacialPositionValues(value: Float){
        print("UPDATE FACIAL POSITION")
        print(headCurrentXPosition)
        print(headCurrentYPosition)
        print(headCurrentZPosition)
        switch currentAttribute{
        case headXPosition: headCurrentXPosition = value/2.0
        case headYPosition: headCurrentYPosition = value/2.0
        case headZPosition: headCurrentZPosition = value/2.0
        default: print("Default")
        }
    
    }
    
}


