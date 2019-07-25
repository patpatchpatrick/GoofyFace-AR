//
//  mainUIViewModel.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/13/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import UIKit

//View Model for Main UI
class MainUIViewModel : MainUIViewModelProtocol{
    
    var appMode = 0
    var appModeChanged = false
    var model: MainUIModel
    var viewDelegate: MainUIViewModelViewDelegate
    var recording = false
    
    init(model: MainUIModel, delegate: MainUIViewModelViewDelegate ) {
        self.model = model
        self.viewDelegate = delegate
    }
    
    func primaryModeChanged(appMode: Int){
        if appMode != self.appMode{
            appModeChanged = true
            self.viewDelegate.mainAppModeChanged(to: appMode)
        }
        self.appMode = appMode
    }
    
    func tattooModeChanged(mode: Mode, button: UIButton){
        self.viewDelegate.unselectAllButtons()
        self.viewDelegate.selectButton(button: button)
        self.viewDelegate.tattooModeChanged(to: mode, self)
        self.viewDelegate.hideSecondaryMenu()
    }
    
    func modeChangedToShare(previewWindowOpen: Bool, snapshot: UIImage?, button: UIButton){
        
        self.viewDelegate.unselectAllButtons()
        self.viewDelegate.selectButton(button: button)
        
        if previewWindowOpen {
            //If user clicks share button while the preview window is still open, reload the shareImage menu
            guard let currentImg = model.selectedPreviewImage else {return}
            self.viewDelegate.shareImage(image: currentImg)
            return
        }
        //Return if image to share is nil
        guard let selectedImage = snapshot else {return}
        
        //Hide buttons so a snapshot of user can be taken
        self.viewDelegate.hideButtonsForSnapshot()
        viewDelegate.hideSecondaryMenu()
        
        //Play camera snapshot sound
        self.viewDelegate.playSnapshotSound()
        
        //Show the preview of the image that the user took and allow them to share it
        //If user is in "premium mode", remove the watermark
        //Also save the preview in the model
        let premiumModePurchased = model.premiumModePurchased
        if !premiumModePurchased{
            if let watermarkedImage = addWatermarkToImage(imageToWatermark: selectedImage){
                model.selectedPreviewImage = watermarkedImage
                viewDelegate.setAndShowPreviewImage(image: watermarkedImage)
                viewDelegate.shareImage(image: watermarkedImage)
            }
        } else {
            model.selectedPreviewImage = selectedImage
            viewDelegate.setAndShowPreviewImage(image: selectedImage)
            viewDelegate.shareImage(image: selectedImage)
        }
    }
    
    func addWatermarkToImage(imageToWatermark: UIImage) -> UIImage?{
        if let img2 = UIImage(named: "watermark.png") {
            
            let rect = CGRect(x: 0, y: 0, width: imageToWatermark.size.width, height: imageToWatermark.size.height)
            
            UIGraphicsBeginImageContextWithOptions(imageToWatermark.size, true, 0)
            guard let context = UIGraphicsGetCurrentContext() else {return nil}
            
            context.setFillColor(UIColor.white.cgColor)
            context.fill(rect)
            
            imageToWatermark.draw(in: rect, blendMode: .normal, alpha: 1)
            img2.draw(in: CGRect(x: imageToWatermark.size.width / 2 - img2.size.width / 2,y: imageToWatermark.size.height - 400,width: 800,height: 400), blendMode: .normal, alpha: 0.3)
            img2.draw(in: CGRect(x: imageToWatermark.size.width / 2 - img2.size.width / 2,y: 0,width: 800,height: 400), blendMode: .normal, alpha: 0.3)
            
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return result
        } else {return nil}
    }
    
    func checkIfUserHasPremiumAccess(){

        if model.premiumModePurchased{
            self.viewDelegate.premiumModeUnlocked()
        }
        
    }
    
    func activatePremiumAccess(){
        model.activatePremiumAccess()
        viewDelegate.premiumModeUnlocked()
    }
    
    func drawnImageFullScreenModeRequested(){
        let unlocked = model.premiumModePurchased
        viewDelegate.setViewsForFullScreenDrawnImage(unlocked: unlocked)
    }
    
    func colorPickerRequested(){
        let unlocked = model.premiumModePurchased
        viewDelegate.setViewsForColorPicker(unlocked: unlocked)
    }
    
    func hideAllTattooSubMenus(){
        
        viewDelegate.hideTattooSubMenus()
    }
    
    func selectTattooType(button: UIButton){
        self.viewDelegate.unselectAllButtons()
        self.viewDelegate.selectButton(button: button)
        viewDelegate.toggleTattooModeMenu()
    }
    
    func showColorPicker(){
        viewDelegate.showColorPicker()
    }
    
    func reset(){
        self.viewDelegate.unselectAllButtons()
        self.viewDelegate.hideSecondaryMenu()
        self.viewDelegate.hideTattooSubMenus()
    }
    
    func transformButtonSelected(button: UIButton){
        viewDelegate.unselectAllButtons()
        viewDelegate.selectButton(button: button)
    }
    
    func recordButtonTapped(){
        if !recording {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    func startRecording(){
        viewDelegate.startScreenRecording()
    }
    
    func stopRecording(){
        viewDelegate.stopScreenRecording()
    }
    
    
}
    
    

