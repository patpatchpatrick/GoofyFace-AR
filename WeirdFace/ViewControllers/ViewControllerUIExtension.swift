//
//  ViewControllerUIExtension.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/9/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import UIKit

//Class to keep track of updates to UI
extension ViewController {
    
    func configureButtonsAndViews(){
        
        //Add shadow to all buttons
        addShadowToView(view: drawnImageFullScreenAcceptButton)
        addShadowToView(view: drawnImageFullScreenUndoButton)
        addShadowToView(view: drawnImageFullScreenDiscardButton)
        addShadowToView(view: drawnImageViewFullScreenButton)
        addShadowToView(view: colorPickerButton)
        addShadowToView(view: colorPickerFullScreenButton)
        addShadowToView(view: drawnImageAcceptButton)
        addShadowToView(view: drawnImageDiscardButton)
        addShadowToView(view: resetButton)
        addShadowToView(view: uploadImageDiscardButton)
        addShadowToView(view: uploadImageAcceptButton)
        addShadowToView(view: transformHideButton)
        addShadowToView(view: transformLeftButton)
        addShadowToView(view: transformRightButton)
        addShadowToView(view: transformUpButton)
        addShadowToView(view: transformDownButton)
        addShadowToView(view: transformRotateCWButton)
        addShadowToView(view: transformRotateCCWButton)
        addShadowToView(view: transformMinusButton)
        addShadowToView(view: transformPlusButton)
        addShadowToView(view: transformPositionAcceptButton)
        addShadowToView(view: discardPreviewButton)
        addShadowToView(view: removeWatermarkButton)
        addShadowToView(view: settingsButton)
        
        addShadowToView(view: settingsContainer)
        addShadowToView(view: drawnImageFullScreenRotateMessage)
        rotateFullScreenImages()
    }
    
    func configureViewsForPremiumMode(isPremium: Bool ){
        
        //Remove icons with locks on them
        
        if isPremium {
            let fullScreenUnlockedImg = UIImage(named: "iconFullScreen.png")
            drawnImageViewFullScreenButton.setImage(fullScreenUnlockedImg, for: .normal)
            let colorPickUnlockedImg = UIImage(named: "iconColorWheel.png")
            colorPickerButton.setImage(colorPickUnlockedImg, for: .normal)
            purchasePremiumButton.isEnabled = false
            purchasePremiumButton.setTitle("Premium Mode Purchased", for: .normal)
            
            //Hide watermark and remove watermark button
            watermark.isHidden = true
            removeWatermarkButton.isHidden = true
        } else {
            let fullScreenLockedImg = UIImage(named: "iconFullScreenLocked.png")
            drawnImageViewFullScreenButton.setImage(fullScreenLockedImg, for: .normal)
            let colorPickLockedImg = UIImage(named: "iconColorWheelLocked.png")
            colorPickerButton.setImage(colorPickLockedImg, for: .normal)
            purchasePremiumButton.isEnabled = true
            purchasePremiumButton.setTitle("Purchase Premium Mode", for: .normal)
            
            //Hide watermark and remove watermark button
            watermark.isHidden = false
            removeWatermarkButton.isHidden = false
            
        }
    
    }
    
    func addShadowToView(view: UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 1.0
        view.clipsToBounds = false
    }
    
    func rotateFullScreenImages(){
        //Rotate the buttons in the full screen imageview since user will be using the screen in landscape mode
        drawnImageFullScreenAcceptButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        
        drawnImageFullScreenUndoButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        
    }
    
}
