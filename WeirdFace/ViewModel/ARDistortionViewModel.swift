//
//  ARDistortionViewModel.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/22/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import UIKit

class ARDistortionViewModel : ARDistortionViewModelProtocol{
    
    var model: ARDistortionModel
    var viewDelegate: ARDistortionViewModelViewDelegate
    
    var currentEditMode:Int = -1 //Current facial edit mode
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
    
    func resetEditMode(){
        //When the edit menu is collapsed, set value back to default (-1)
        currentEditMode = -1
    }
    
    func distortionEditModeChanged(editMode: Int, button: UIButton){
        //Set up the views depending on the type of distortion edit mode that the user selected
        //Unselect buttons, then select the one that was chosen corresponding to the edit mode that was selected
        //Set the value of the current edit mode
        let modeChanged = editMode != currentEditMode
        viewDelegate.hideModeSelectMenu()
        currentEditMode = editMode
        viewDelegate.unselectDistortionEditButtons()
        viewDelegate.distortionButtonSelected(button: button)
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
        
        if !modeChanged {
            //If same button was tapped twice, collapse the secondary menu
            viewDelegate.collapseSecondaryMenuIfExpanded()
        }
        
    }
    
    func modeSelectMenuTapped(){
        
        hideAllSubMenus()
        viewDelegate.toggleModeSelectMenu()
        
    }
    
    func reset(){
        
        //Reset positions/sizes
        
        headDistortion = 1.0
        eyeDistortion = 1.0
        noseDistortion = 1.0
        mouthDistortion = 1.0
        
        headCurrentXPosition = 0.0
        headCurrentYPosition = 0.0
        headCurrentZPosition = 0.0
        
    }
    
    func hideAllSubMenus(){
        
        viewDelegate.toggleSecondaryMenu(hidden: true)
        viewDelegate.toggleSecondarySizeSubMenu(hidden: true)
        viewDelegate.toggleSecondaryPositionSubMenu(hidden: true)
        viewDelegate.toggleFeatureSlider(hidden: true)
        
    }
    
    func setCurrentFeatureBeingEdited(feature: Int, button: UIButton){
        //Unselect buttons, then select the tapped button and mark the attribtue that was selected as the current attribute
        if feature != currentAttribute {
            //If attribute changed, reset the slider value to default
            viewDelegate.resetFeaturesSlider()
        }
        viewDelegate.unselectPositionButtons()
        viewDelegate.unselectFeatureButtons()
        viewDelegate.distortionButtonSelected(button: button)
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
        //For positions, subtract 1.5 (since the slider values go from 0 - 3.0, 1.5 is subtracted because the position should move left/negative if less than halfway and right/positive if more than halfway
        switch currentAttribute{
        case headXPosition: headCurrentXPosition = (value - 1.5) * 2.0
        case headYPosition: headCurrentYPosition = (value - 1.5) * 2.0
        case headZPosition: headCurrentZPosition = (value - 1.5) * 2.0
        default: print("Default")
        }
    
    }
    
}


