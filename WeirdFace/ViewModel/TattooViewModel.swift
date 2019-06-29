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
            self.rotation += 0.1
        } else {
            self.rotation -= 0.1
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
        
        DispatchQueue.global(qos: .background).async {
            guard let image = self.tattoo.image else {return}
            
            //Resize image.  If auto, use Tattoo type default values.  If manual, use viewModel manual values
            var resizedImg: UIImage?
            switch self.positionType {
            case .auto:    resizedImg = resizeImage(image: image, targetSize: CGSize(width: self.tattoo.width, height: self.tattoo.height))
            case .manual:  resizedImg = resizeImage(image: image, targetSize: CGSize(width: self.width, height: self.height))
            }
            
              //Rotate image.  If auto, use Tattoo type default values.  If manual, use viewModel manual values
            var rotatedImage: UIImage?
            switch self.positionType {
            case .auto:    rotatedImage = resizedImg!.rotate(radians: self.tattoo.rotation)
            case .manual:  rotatedImage = resizedImg!.rotate(radians: self.rotation)
            }
            
            let expandedSize = CGSize(width: defaultCanvasWidth, height: defaultCanvasHeight)
            
              //Position image.  If auto, use Tattoo type default values.  If manual, use viewModel manual values
            var currentCanvas : UIImage?
            switch self.positionType {
            case .auto:    currentCanvas = drawImageOnCanvas(rotatedImage!, canvas: self.canvas, canvasSize: expandedSize, x: self.tattoo.x, y: self.tattoo.y)
            case .manual:  currentCanvas = drawImageOnCanvas(rotatedImage!, canvas: self.canvas, canvasSize: expandedSize, x: self.x, y: self.y)
            }
            
            self.image = currentCanvas?.alpha(0.8)
            
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
        
        //Reload a blank image
        DispatchQueue.global(qos: .background).async {
            
            guard let resetImage = UIImage(named: "blank") else {return}
            let expandedSize = CGSize(width: defaultCanvasWidth, height: defaultCanvasHeight)
            let resizedResetImg = resizeImage(image: resetImage, targetSize: CGSize(width: 1, height: 1))
            let resetRotatedImage = resizedResetImg.rotate(radians: 0)
            let currentCanvas = drawImageOnCanvas(resetRotatedImage!, canvas: self.canvas, canvasSize: expandedSize, x: 999 , y: 999)
            self.image = currentCanvas.alpha(0.8)
            
            self.x = 400
            self.y = 400
            self.width = 200
            self.height = 100
            self.rotation = 0
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("UPDATED_DATA"), object: nil)
            }
        }
        
        
    }
    
    func commitTattoo(){
      
        //When tattoo is committed, the current canvas (i.e. AR face map) becomes the canvas.  Then, the current canvas is reset to a blank image.
        //Generate the current canvas image, conver the current canvas to the canvas, then clear the canvas by creating a new blank image.
        
        DispatchQueue.global(qos: .background).async {
            guard let image = self.tattoo.image else {return}
            let resizedImg = resizeImage(image: image, targetSize: CGSize(width: self.width, height: self.height))
            let rotatedImage = resizedImg.rotate(radians: self.rotation)
            let expandedSize = CGSize(width: defaultCanvasWidth, height: defaultCanvasHeight)
            self.canvas = drawImageOnCanvas(rotatedImage!, canvas: self.canvas, canvasSize: expandedSize, x: self.x, y: self.y)
            self.image = self.canvas?.alpha(0.8)
            
            guard let resetImage = UIImage(named: "blank") else {return}
            let resizedResetImg = resizeImage(image: resetImage, targetSize: CGSize(width: 1, height: 1))
            let resetRotatedImage = resizedResetImg.rotate(radians: 0)
            let currentCanvas = drawImageOnCanvas(resetRotatedImage!, canvas: self.canvas, canvasSize: expandedSize, x: 999 , y: 999)
            self.image = currentCanvas.alpha(0.8)
            
            //reset default position and tattoo types
            self.positionType = .auto
            self.tattoo.type = .new
            
            self.x = 400
            self.y = 400
            self.width = 200
            self.height = 100
            self.rotation = 0
            
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
    
}
