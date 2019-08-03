//
//  ARDistortionViewModel.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/22/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import UIKit

//View Model for Distorting AR Facial Geometry
class ARDistortionViewModel : ARDistortionViewModelProtocol{
    
    var model: ARDistortionModel
    var viewDelegate: ARDistortionViewModelViewDelegate
    
    var currentEditMode:Int = -1 //Current facial edit mode
    var currentAttribute:Int = 0 //Current feature being edited
    
    var headDistortion: Float = 1.0 //Magnitude of eye distortion
    var eyeDistortion: Float = 1.0 //Magnitude of eye distortion
    var noseDistortion: Float = 1.0 //Magnitude of nose distortion
    var mouthDistortion: Float = 1.0 //Magnitude of nose distortion
    
    var headAnimationEnabled = false //Bool to track whether to animate features
    var eyeAnimationEnabled = false //Bool to track whether to animate features
    var noseAnimationEnabled = false //Bool to track whether to animate features
    var mouthAnimationEnabled = false //Bool to track whether to animate features
    
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
            viewDelegate.toggleAnimationContainer(hidden: true)
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
        
        headAnimationEnabled = false
        eyeAnimationEnabled = false
        noseAnimationEnabled = false
        mouthAnimationEnabled = false
        
        
        viewDelegate.unselectFeatureButtons()
        viewDelegate.unselectPositionButtons()
        viewDelegate.unselectDistortionEditButtons()
        
    }
    
    func hideAllSubMenus(){
        
        viewDelegate.toggleSecondaryMenu(hidden: true)
        viewDelegate.toggleSecondarySizeSubMenu(hidden: true)
        viewDelegate.toggleSecondaryPositionSubMenu(hidden: true)
        viewDelegate.toggleFeatureSlider(hidden: true)
        viewDelegate.toggleAnimationContainer(hidden: true)
        
    }
    
    func setCurrentFeatureBeingEdited(feature: Int, button: UIButton){
        //Unselect buttons, then select the tapped button and mark the attribtue that was selected as the current attribute
        
        viewDelegate.toggleFeatureSlider(hidden: false)
        switch currentEditMode{
            //Only show animation container if size of the features are being edited.
            //Animations are not currently enabled for positions
        case facialSizeMode:
            viewDelegate.toggleAnimationContainer(hidden: false)
        case facialPositionMode:
            viewDelegate.toggleAnimationContainer(hidden: true)
        default:
            print("Default")
        }
    
        if feature != currentAttribute {
            //If attribute changed, reset the slider value to default
            viewDelegate.resetFeaturesSlider()
            viewDelegate.resetAnimationSwitch()
        }
        viewDelegate.unselectPositionButtons()
        viewDelegate.unselectFeatureButtons()
        viewDelegate.distortionButtonSelected(button: button)
        currentAttribute = feature
        setAnimationSwitchBasedOnCurrentFeatureState()
    }
    
    func setAnimationSwitchBasedOnCurrentFeatureState(){
        switch currentAttribute{
        case featureHead: viewDelegate.setAnimationSwitchValue(isOn: headAnimationEnabled)
        case featureEyes: viewDelegate.setAnimationSwitchValue(isOn: eyeAnimationEnabled)
        case featureNose: viewDelegate.setAnimationSwitchValue(isOn: noseAnimationEnabled)
        case featureMouth: viewDelegate.setAnimationSwitchValue(isOn: mouthAnimationEnabled)
        default: print("Default")
        }
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
    
    func animateSwitchFlipped(state: Bool){
        
        //When the animate switch is flipped, update the animation state of the feature that is currently being edited
        
        switch currentAttribute{
        case featureHead: headAnimationEnabled = state
        case featureEyes: eyeAnimationEnabled = state
        case featureNose: noseAnimationEnabled = state
        case featureMouth: mouthAnimationEnabled = state
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
    
    func getEyeAnimationValue() -> Float{
        //Animation value for Shader, used to let the shader know whether or not to animate this feature
        if eyeAnimationEnabled {
            return 1.0
        } else {
            return 0.0
        }
    }
    
    func getNoseAnimationValue() -> Float{
        //Animation value for Shader, used to let the shader know whether or not to animate this feature
        if noseAnimationEnabled {
            return 1.0
        } else {
            return 0.0
        }
    }
    
    func getMouthAnimationValue() -> Float{
        //Animation value for Shader, used to let the shader know whether or not to animate this feature
        if mouthAnimationEnabled {
            return 1.0
        } else {
            return 0.0
        }
    }
    
    func getHeadAnimationValue() -> Float{
        //Animation value for Shader, used to let the shader know whether or not to animate this feature
        if headAnimationEnabled {
            return 1.0
        } else {
            return 0.0
        }
    }
    
    
    
}


