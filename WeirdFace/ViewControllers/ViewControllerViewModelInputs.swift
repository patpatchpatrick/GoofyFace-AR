//
//  ViewControllerViewModelInputs.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/25/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SceneKit
import StoreKit

//View Controller Extension to handle all input received via ViewModels
extension ViewController: ARImageViewModelViewDelegate{
    
    func acceptImageSize() {
        //Hide the size picker and show the resize buttons again
        acceptSizeButton.isHidden = true
        sizePicker.isHidden = true
        //Reset size picker to reselect initial item after a size is chosen
        sizePicker.selectRow(0, inComponent:0, animated:true)
        resizeButtonContainer.isHidden = false
    }
    
    
    func fullScreenDrawingDiscarded() {
        drawnImageViewFullScreenContainer.isHidden = true
        drawnImageViewFullScreen.clear()
    }
    
    
    func selectDefaultSize() {
        //Allow user to select a default size
        sizePicker.isHidden = false
        //Hide resize buttons while you select a size
        resizeButtonContainer.isHidden = true
    }
    
    
    func customImageChanged() {
        collectionView.isHidden = true
        resetButton.isHidden = false
        settingsButton.isHidden = false
        configureEnabledButton(button: placeButton)
    }
    
    
    
    func resetARViews(){
        //Reset views to initial state of app
        transformPrimaryContainer.isHidden = true
        repositionButtonContainer.isHidden = true
        rotateButtonContainer.isHidden = true
        resizeButtonContainer.isHidden = true
        configureDisabledButton(button: placeButton)
        configureDisabledButton(button: addButton)
        configureDisabledButton(button: shareButton)
    }
    
    
    func fullScreenDrawingAccepted() {
        //When a full screen drawing is accepted, position tab is enabled for user to position image
        drawnImageViewFullScreenContainer.isHidden = true
        configureEnabledButton(button: placeButton)
    }
    
    func uploadedImageAccepted() {
        //When an uploaded image is accepted, position tab is enabled for user to position image
        uploadedImageContainer.isHidden = true
        configureEnabledButton(button: placeButton)
    }
    
    func manualDrawingAccepted() {
        //After manual drawing is accepted, position tab is enabled for user to position drawing
        drawnImageContainerView.isHidden = true
        configureEnabledButton(button: placeButton)
    }
    
    func arImagePositionAccepted() {
        //Position was accepted, set up views accordingly
        tattooTypePicker.isHidden = true
        sizePicker.isHidden = true
        acceptSizeButton.isHidden = true
        tattooViewModel?.positionType = .manual
        secondaryScrollMenu.isHidden = false
        secondaryTattooTransformSubMenu.isHidden = false
        transformPrimaryContainer.isHidden = false
        acceptPositionButton.isHidden = true
        configureEnabledButton(button: addButton)
        
    }
    
    
    func arImagePositionUpdated() {
        //Let the renderer know that the image has changed
        tattooViewModel?.imageChanged = true
    }
    
    
}

extension ViewController: MainUIViewModelViewDelegate{
    
    func hideTransformControls() {
        //Hide controls for image transformatino
        secondaryScrollMenu.isHidden = true
        secondaryTattooTransformSubMenu.isHidden = true
        transformPrimaryContainer.isHidden = true
    }
    
    //Set up views for image transformation
    func setViewsForImageTransformation(type: ImageTransformationType) {
        switch type{
        case .reposition:
            //Hide/show reposition buttons
            repositionButtonContainer.isHidden = !repositionButtonContainer.isHidden
            
            //Hide other transform containers
            resizeButtonContainer.isHidden = true
            rotateButtonContainer.isHidden = true
        case .resize:
            //Hide/show resize buttons
            resizeButtonContainer.isHidden = !resizeButtonContainer.isHidden
            tattooViewModel?.arPickerType = .size
            sizePicker.reloadAllComponents()
            
            //Hide other transform containers
            repositionButtonContainer.isHidden = true
            rotateButtonContainer.isHidden = true
        case .rotate:
            rotateButtonContainer.isHidden = !rotateButtonContainer.isHidden
            
            //Hide other transform containers
            repositionButtonContainer.isHidden = true
            resizeButtonContainer.isHidden = true
        }
    }
    
    
    func showColorPicker() {
        colorPicker.isHidden = false
    }
    
    func startScreenRecording() {
        rpStartRecording()
    }
    
    func stopScreenRecording() {
        rpStopRecording()
    }
    
    func hideSecondaryMenu() {
        secondaryScrollMenu.isHidden = true
        secondaryTattooModeSubMenu.isHidden = true
        secondaryTattooTransformSubMenu.isHidden = true
        featuresSlider.isHidden = true
    }
    
    
    func toggleTattooModeMenu() {
        secondaryScrollMenu.isHidden = !secondaryScrollMenu.isHidden
        secondaryTattooModeSubMenu.isHidden = secondaryScrollMenu.isHidden
    }
    
    
    func hideTattooSubMenus() {
        acceptPositionButton.isHidden = true
        acceptSizeButton.isHidden = true
        tattooTypePicker.isHidden = true
        sizePicker.isHidden = true
        secondaryScrollMenu.isHidden = true
        secondaryTattooTransformSubMenu.isHidden = true
        secondaryTattooModeSubMenu.isHidden = true
        transformPrimaryContainer.isHidden = true
        drawnImageContainerView.isHidden = true
        uploadedImageContainer.isHidden = true
        drawnImageViewFullScreenContainer.isHidden = true
        hideImagePreview()
    }
    
    
    func unselectAllButtons() {
        for button in tattooMainMenuButtons {
            configureButtonAsUnselected(button: button)
        }
        for button in tattooTransformButtons {
            configureButtonAsUnselected(button: button)
        }
        for button in distortionEditModeButtons {
            configureButtonAsUnselected(button: button)
        }
    }
    
    func selectButton(button: UIButton) {
        configureButtonAsSelected(button: button)
    }
    
    
    //Main app mode changed (between tattoo and face distort)
    //Show appropriate menus
    func mainAppModeChanged(to mode: Int) {
        
        switch mode {
        case modeTattoo:
            tattooScrollMenu.isHidden = false
            faceDistortScrollMenu.isHidden = true
            secondaryScrollMenu.isHidden = true
            featuresSlider.isHidden = true
        case modeFaceDistortion:
            tattooScrollMenu.isHidden = true
            faceDistortScrollMenu.isHidden = false
        default:
            print("Default")
        }
    }
    
    
    //If user has premium mode, configure views accordingly
    func premiumModeUnlocked() {
        configureViewsForPremiumMode(isPremium: true)
    }
    
    //Share image using other applications
    func shareImage(image: UIImage) {
        displayShareImageWindow(image: image)
    }
    
    //Set and show the user a preview of their snapshot
    func setAndShowPreviewImage(image: UIImage) {
        previewImage.image = image
        previewImageContainer.isHidden = false
    }
    
    func hideButtonsForSnapshot(){
        repositionButtonContainer.isHidden = true
        rotateButtonContainer.isHidden = true
        resizeButtonContainer.isHidden = true
        transformPrimaryContainer.isHidden = true
        settingsButton.isHidden = false
    }
    
    func playSnapshotSound() {
        //Play camera shutter sound
        AudioServicesPlaySystemSound(1108)
    }
    
    //Handle UI changes when the user changes the "mode" of the app
    
    func tattooModeChanged(to mode: Mode, _ viewModel: MainUIViewModel) {
        
        resetViewsToDefault()
        
        switch mode {
        case .custom: modeChangedToCustom()
        case .draw: modeChangedToDraw()
        case .upload: modeChangedToUpload()
        case .position: modeChangedToPosition()
        case .place: modeChangedToPlace()
        default:
            print("default")
        }
    }
    
    func resetViewsToDefault(){
        
        collectionView.isHidden = true
        resetButton.isHidden = false
        settingsButton.isHidden = false
        drawnImageContainerView.isHidden = true
        uploadedImageContainer.isHidden = true
        tattooTypePicker.isHidden = true
        acceptPositionButton.isHidden = true
        repositionButtonContainer.isHidden = true
        rotateButtonContainer.isHidden = true
        resizeButtonContainer.isHidden = true
        transformPrimaryContainer.isHidden = true
        
    }
    
    func modeChangedToCustom() {
        collectionView.isHidden = false
        resetButton.isHidden = true
        settingsButton.isHidden = true
        previewImageContainer.isHidden = true
    }
    
    func modeChangedToDraw() {
        resetDrawView()
        drawnImageContainerView.isHidden = false
        previewImageContainer.isHidden = true
    }
    
    func modeChangedToUpload() {
        resetUploadView()
        uploadedImageContainer.isHidden = false
        previewImageContainer.isHidden = true
        selectUploadPicture()
    }
    
    func modeChangedToPosition() {
        tattooTypePicker.isHidden = false
        sizePicker.isHidden = true
        acceptSizeButton.isHidden = true
        previewImageContainer.isHidden = true
        tattooTypePicker.reloadAllComponents() //reload picker view to contain position data
    }
    
    func modeChangedToPlace() {
        repositionButtonContainer.isHidden = true
        resizeButtonContainer.isHidden = true
        rotateButtonContainer.isHidden = true
        transformPrimaryContainer.isHidden = true
        sizePicker.isHidden = true
        acceptSizeButton.isHidden = true
        configureEnabledButton(button: shareButton)
        configureDisabledButton(button: addButton)
        configureDisabledButton(button: placeButton)
        settingsButton.isHidden = false
        previewImageContainer.isHidden = true
    }
    
    func setViewsForColorPicker(unlocked: Bool) {
        //Show color wheel if premium account purchased, otherse show alert with option to purchase
        if unlocked {
            colorPicker.isHidden = false
        } else {
            colorPickerButton.isEnabled = false
            self.buyInAppPurchases()
        }
    }
    
    
    func setViewsForFullScreenDrawnImage(unlocked: Bool) {
        //Show color wheel if premium account purchased, otherwise show alert with option to purchase
        if unlocked {
            drawnImageViewFullScreenContainer.isHidden = false
            drawnImageContainerView.isHidden = true
            switch UIDevice.current.orientation{
            case .portrait, .portraitUpsideDown:
                //Show message that tells user to rotate device if screen is not landscape
                drawnImageFullScreenRotateMessage.isHidden = false
            default:
                print("Orientation Is Correct")
            }
        } else {
            drawnImageViewFullScreenButton.isEnabled = false
            self.buyInAppPurchases()
        }
    }
    
}

extension ViewController: ARDistortionViewModelViewDelegate{
    
    func toggleFeatureSlider(hidden: Bool) {
        featuresSlider.isHidden = hidden
    }
    
    
    func toggleModeSelectMenu() {
        modeSelectMenu.isHidden = !modeSelectMenu.isHidden
    }
    
    
    func hideModeSelectMenu(){
        modeSelectMenu.isHidden = true
    }
    
    func resetFeaturesSlider() {
        featuresSlider.setValue(1.0, animated: true)
    }
    
    
    func collapseSecondaryMenuIfExpanded() {
        if !secondaryScrollMenu.isHidden {
            secondaryScrollMenu.isHidden = true
            hideAndResetFeaturesSlider()
            distortionViewModel?.resetEditMode()
        }
    }
    
    
    func unselectDistortionEditButtons() {
        for button in distortionEditModeButtons {
            configureButtonAsUnselected(button: button)
        }
    }
    
    
    func unselectPositionButtons() {
        for button in positionButtons {
            configureButtonAsUnselected(button: button)
        }
    }
    
    
    func unselectFeatureButtons() {
        for button in featureButtons {
            configureButtonAsUnselected(button: button)
        }
    }
    
    
    func distortionButtonSelected(button: UIButton) {
        configureButtonAsSelected(button: button)
    }
    
    
    func toggleSecondaryMenu(hidden: Bool) {
        secondaryScrollMenu.isHidden = hidden
    }
    
    func toggleSecondarySizeSubMenu(hidden: Bool) {
        secondarySizeSubMenu.isHidden = hidden
    }
    
    func toggleSecondaryPositionSubMenu(hidden: Bool) {
        secondaryPositionSubMenu.isHidden = hidden
    }
    
    
}

