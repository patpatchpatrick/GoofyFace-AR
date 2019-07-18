//
//  TattooViewModel.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 6/27/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import UIKit

let defaultCanvasHeight:CGFloat = 1000
let defaultCanvasWidth:CGFloat = 1000

public class ARViewModel:ARViewModelProtocol {
    var model: ARModel
    var viewDelegate: ARViewModelViewDelegate

    var image: UIImage?
    var canvas: UIImage?
    var lastCanvas: UIImage?
    enum PositionType {
        case manual
        case auto
    }
    var arPickerType: ARPickerType = .position //Type of data being shown in the picker
    
    var positionType:PositionType = .auto
    //Manual positions (override default tattoo positions if the user decides to move the tattoo)
    var x: CGFloat = 400
    var y: CGFloat = 400
    var width: CGFloat = 200
    var height: CGFloat = 100
    var rotation: Float = 0
    var size: ARImageSize = .small
    let xMax: CGFloat = 799
    let xMin: CGFloat = 100
    let yMax: CGFloat = 700
    let yMin: CGFloat = 100
    let widthMax: CGFloat = 800
    let heightMax: CGFloat = 400
    let widthMin: CGFloat = 50
    let heightMin: CGFloat = 25
    
    
    init(tattooModel: ARModel, delegate: ARViewModelViewDelegate) {
        self.model = tattooModel
        self.viewDelegate = delegate
    }
    
    func incrementX(multiplier: CGFloat){
        //Increment image x position
        if self.x < xMax {
                   self.x += 10 * multiplier
            loadImage()
        }
    }
    
    func decrementX(multiplier: CGFloat){
          //Decrement image x position
        if self.x > xMin {
            self.x -= 10 * multiplier
            loadImage()
        }
    }
    
    func incrementY(multiplier: CGFloat){
        //Increment image y position
        if self.y < yMax {
            self.y += 10 * multiplier
            loadImage()
        }
    }
    
    func decrementY(multiplier: CGFloat){
        //Decrement image y position
        if self.y > yMin {
            self.y -= 10 * multiplier
            loadImage()
        }
    }
    
    func rotate(clockwise: Bool){
        //Rotate tattoo by 0.1 radians when rotate is called
        if clockwise {
            self.rotation -= 0.1
        } else {
            self.rotation += 0.1
        }
        loadImage()
    }
    
    func incrementSize(multiplier: CGFloat){
        //Scale image.  Keep proportions 2:1
        if self.width < widthMax && self.height < heightMax {
            self.width += 10 * multiplier
            self.height += 5 * multiplier
            loadImage()
        }
    }
    
    func decrementSize(multiplier: CGFloat){
        //Scale image.  Keep proportions 2:1
        if self.height > heightMin && self.width > widthMin {
            self.width -= 10 * multiplier
            self.height -= 5 * multiplier
            loadImage()
        }
    }
    
    func setDefaultSize(size: ARImageSize?){
        guard let size = size else {return}
        if size != self.size {
            let multiplier: CGFloat  = CGFloat(size.rawValue) / CGFloat(self.size.rawValue)
     
                self.width = self.width * multiplier
                self.height = self.height * multiplier
                setDefaultSizePositionModifier(size: size)
                self.size = size
                loadImage()
                print("Multiplier", multiplier)
            
        }
    }
    
    func setDefaultSizePositionModifier(size: ARImageSize){
        //Adjust the position of the tattoo when the size changes
        let multiplier: CGFloat  = CGFloat(size.rawValue) - CGFloat(self.size.rawValue)
        
        switch self.model.type{
        case .forehead:
            self.x += multiplier * -100
            self.y += multiplier * -50
        case .leftBrow:
            self.x += multiplier * -100
            self.y += multiplier * -50
        case .rightBrow:
            self.x += multiplier * -100
            self.y += multiplier * -50
        case .leftCheek:
            self.x += multiplier * -100
            self.y += multiplier * -50
        case .nose:
            self.x += multiplier * -100
            self.y += multiplier * -50
        case .rightCheek:
            self.x += multiplier * -100
            self.y += multiplier * -50
        case .lowerLip:
            self.x += multiplier * -100
            self.y += multiplier * -50
        case .new:
            print("ans")
        }
        
        
    }
    
    func acceptPosition(){
        
        //Set the manual position of the image to match the default tattoo's position when the image's position is chosen via the picker view
        
        self.x = self.model.x
        self.y = self.model.y
        self.rotation = self.model.rotation
        self.width = self.model.width
        self.height = self.model.height
        self.size = .small
        self.positionType = .manual
        self.viewDelegate.arImagePositionAccepted()
        
    }
    
    func loadImage(){
        
        //Reload the tattoo image
        //If auto-positioning, use the default tattoo positions
        //If manual-positioning, use the manual positions
        
        DispatchQueue.global(qos: .background).async {
        
            guard let image = self.model.image else {return}
            
            switch self.positionType {
            case .auto: self.reloadImage(image: image, width: self.model.width, height: self.model.height, radians: self.model.rotation, x: self.model.x, y: self.model.y, resetToDefault: false, commitImage: false)
            case .manual: self.reloadImage(image: image, width: self.width, height: self.height, radians: self.rotation, x: self.x, y: self.y, resetToDefault: false, commitImage: false)
            }
            
            DispatchQueue.main.async {
                self.viewDelegate.arImagePositionUpdated()
            }
        }
        
    }
    
    func reset(){
        
        //reset default position and tattoo types
        self.positionType = .auto
        self.model.type = .new
        
        //Set canvas back to nil to reset the image
        self.canvas = nil
        
        DispatchQueue.global(qos: .background).async {
            
            //Reload a blank image
            guard let resetImage = UIImage(named: "blank") else {return}
            self.reloadImage(image: resetImage, width: 1, height: 1, radians: 0, x: 999, y: 999, resetToDefault: true, commitImage: false)
            
            DispatchQueue.main.async {
                self.viewDelegate.arImagePositionUpdated()
                self.viewDelegate.resetARViews()
            }
        }
        
        
    }
    
    func commitTattoo(){
      
        //When tattoo is committed, the current canvas (i.e. AR face map) becomes the canvas.  Then, the current canvas is reset to a blank image.
        //Generate the current canvas image, conver the current canvas to the canvas, then clear the canvas by creating a new blank image.
        
        DispatchQueue.global(qos: .background).async {
            
            //Commit the current image
            guard let image = self.model.image else {return}
            self.reloadImage(image: image, width: self.width, height: self.height, radians: self.rotation, x: self.x, y: self.y, resetToDefault: false, commitImage: true)
    
            //Reset default position and tattoo types
            self.positionType = .auto
            self.model.type = .new
            
            //Reset the image to be blank after a tattoo is committed
            guard let resetImage = UIImage(named: "blank") else {return}
            self.reloadImage(image: resetImage, width: 1, height: 1, radians: 0, x: 999, y: 999, resetToDefault: true, commitImage: false)
            
            DispatchQueue.main.async {
                 self.viewDelegate.arImagePositionUpdated()
            }
        }
    }
    
    func displayPositionMap(){
        
        //Set the image on the user's face to show a map of tattoo positions
        
        DispatchQueue.global(qos: .background).async {
            guard let image = UIImage(named: "positionMap") else {return}
            self.image = image
            DispatchQueue.main.async {
                 self.viewDelegate.arImagePositionUpdated()
            }
        }
        
        
    }
    
    func changeTattooType(type: FacialPosition){
        self.model.type = type
        loadImage()
    }
    
    func changeImage(named: String){
        self.model.imageName = named
        loadImage()
    }
    
    func changeImage(image: UIImage){
        self.model.image = image
        loadImage()
    }
    
    func manualDrawingAccepted(){
        self.viewDelegate.manualDrawingAccepted()
    }
    
    func uploadedImageAccepted(){
        self.viewDelegate.uploadedImageAccepted()
    }
    
    func fullScreenDrawingAccepted(){
        self.viewDelegate.fullScreenDrawingAccepted()
    }
    
    func reloadImage(image: UIImage, width: CGFloat, height: CGFloat, radians: Float, x:CGFloat, y: CGFloat, resetToDefault: Bool, commitImage: Bool){
        
        //Reload the image using position, scale (width + height), rotation
        
        //Resize image
        let resizedImg = resizeImage(image: image, targetSize: CGSize(width: width, height: height))
        
        //Rotate image.  If auto, use Tattoo type default values.  If manual, use viewModel manual values
        let rotatedImage = resizedImg.rotate(radians: radians)
        
        //Set canvas size.  Currently , it is always the default size.
        let expandedSize = CGSize(width: defaultCanvasWidth, height: defaultCanvasHeight)
        
        //Position image.  If you are committing the image, use the self.canvas variable to save the image.
        if commitImage {
            self.canvas = drawImageOnCanvas(rotatedImage!, canvas: self.canvas, canvasSize: expandedSize, x: x, y: y)
            self.image = self.canvas?.alpha(0.8)
        } else {
            let currentCanvas = drawImageOnCanvas(rotatedImage!, canvas: self.canvas, canvasSize: expandedSize, x: x, y: y)
            self.image = currentCanvas.alpha(0.8)
        }
        
        //Reset manual position values to default
        if resetToDefault {
            self.x = self.model.defaultXPosition
            self.y = self.model.defaultYPosition
            self.width = self.model.defaultWidth
            self.height = self.model.defaultHeight
            self.rotation = self.model.defaultRotation
        }
        
    }
    
}
