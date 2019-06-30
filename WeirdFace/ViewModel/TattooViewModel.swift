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

public class TattooViewModel {
    
    private let tattoo: TattooModel
    var image: UIImage?
    var canvas: UIImage?
    var lastCanvas: UIImage?
    enum PositionType {
        case manual
        case auto
    }
    
    var positionType:PositionType = .auto
    //Manual positions (override default tattoo positions if the user decides to move the tattoo)
    var x: CGFloat = 400
    var y: CGFloat = 400
    var width: CGFloat = 200
    var height: CGFloat = 100
    var rotation: Float = 0
    let xMax: CGFloat = 799
    let xMin: CGFloat = 100
    let yMax: CGFloat = 700
    let yMin: CGFloat = 100
    let widthMax: CGFloat = 800
    let heightMax: CGFloat = 400
    let widthMin: CGFloat = 50
    let heightMin: CGFloat = 25
    
    
    public init(tattooModel: TattooModel) {
        self.tattoo = tattooModel
    }
    
    func incrementX(){
        //Increment image x position
        if self.x < xMax {
                   self.x += 10
            loadImage()
        }
    }
    
    func decrementX(){
          //Decrement image x position
        if self.x > xMin {
            self.x -= 10
            loadImage()
        }
    }
    
    func incrementY(){
        //Increment image y position
        if self.y < yMax {
            self.y += 10
            loadImage()
        }
    }
    
    func decrementY(){
        //Decrement image y position
        if self.y > yMin {
            self.y -= 10
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
    
    func incrementSize(){
        //Scale image.  Keep proportions 2:1
        if self.width < widthMax && self.height < heightMax {
            self.width += 10
            self.height += 5
            loadImage()
        }
    }
    
    func decrementSize(){
        //Scale image.  Keep proportions 2:1
        if self.height > heightMin && self.width > widthMin {
            self.width -= 10
            self.height -= 5
            loadImage()
        }
    }
    
    func acceptPosition(){
        
        //Set the manual position of the image to match the default tattoo's position when the image's position is chosen via the picker view
        
        self.x = self.tattoo.x
        self.y = self.tattoo.y
        self.rotation = self.tattoo.rotation
        self.width = self.tattoo.width
        self.height = self.tattoo.height
        
    }
    
    func loadImage(){
        
        //Reload the tattoo image
        //If auto-positioning, use the default tattoo positions
        //If manual-positioning, use the manual positions
        
        DispatchQueue.global(qos: .background).async {
        
            guard let image = self.tattoo.image else {return}
            
            switch self.positionType {
            case .auto: self.reloadImage(image: image, width: self.tattoo.width, height: self.tattoo.height, radians: self.tattoo.rotation, x: self.tattoo.x, y: self.tattoo.y, resetToDefault: false, commitImage: false)
            case .manual: self.reloadImage(image: image, width: self.width, height: self.height, radians: self.rotation, x: self.x, y: self.y, resetToDefault: false, commitImage: false)
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("UPDATED_DATA"), object: nil)
            }
        }
        
    }
    
    func reset(){
        
        //reset default position and tattoo types
        self.positionType = .auto
        self.tattoo.type = .new
        
        //Set canvas back to nil to reset the image
        self.canvas = nil
        
        DispatchQueue.global(qos: .background).async {
            
            //Reload a blank image
            guard let resetImage = UIImage(named: "blank") else {return}
            self.reloadImage(image: resetImage, width: 1, height: 1, radians: 0, x: 999, y: 999, resetToDefault: true, commitImage: false)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("UPDATED_DATA"), object: nil)
            }
        }
        
        
    }
    
    func commitTattoo(){
      
        //When tattoo is committed, the current canvas (i.e. AR face map) becomes the canvas.  Then, the current canvas is reset to a blank image.
        //Generate the current canvas image, conver the current canvas to the canvas, then clear the canvas by creating a new blank image.
        
        DispatchQueue.global(qos: .background).async {
            
            //Commit the current image
            guard let image = self.tattoo.image else {return}
            self.reloadImage(image: image, width: self.width, height: self.height, radians: self.rotation, x: self.x, y: self.y, resetToDefault: false, commitImage: true)
    
            //Reset default position and tattoo types
            self.positionType = .auto
            self.tattoo.type = .new
            
            //Reset the image to be blank after a tattoo is committed
            guard let resetImage = UIImage(named: "blank") else {return}
            self.reloadImage(image: resetImage, width: 1, height: 1, radians: 0, x: 999, y: 999, resetToDefault: true, commitImage: false)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("UPDATED_DATA"), object: nil)
            }
        }
    }
    
    func displayPositionMap(){
        
        //Set the image on the user's face to show a map of tattoo positions
        
        DispatchQueue.global(qos: .background).async {
            guard let image = UIImage(named: "positionMap") else {return}
            self.image = image
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("UPDATED_DATA"), object: nil)
            }
        }
        
        
    }
    
    func changeTattooType(type: TattooType){
        self.tattoo.type = type
        loadImage()
    }
    
    func changeImage(named: String){
        self.tattoo.imageName = named
        loadImage()
    }
    
    func changeImage(image: UIImage){
        self.tattoo.image = image
        loadImage()
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
            self.x = 400
            self.y = 400
            self.width = 200
            self.height = 100
            self.rotation = 0
        }
        
    }
    
}
