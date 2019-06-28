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
    
    public init(tattooModel: TattooModel) {
        self.tattoo = tattooModel
    }
    
    func acceptPosition(){
        
        self.x = self.tattoo.x
        self.y = self.tattoo.y
        self.rotation = self.tattoo.rotation
        self.width = self.tattoo.width
        self.height = self.tattoo.height
        
    }
    
    func loadImage(){
        
        print("Loading Image")
        DispatchQueue.global(qos: .background).async {
            guard let image = self.tattoo.image else {return}
            
            var resizedImg: UIImage?
            switch self.positionType {
            case .auto:    resizedImg = resizeImage(image: image, targetSize: CGSize(width: self.tattoo.width, height: self.tattoo.height))
            case .manual:  resizedImg = resizeImage(image: image, targetSize: CGSize(width: self.width, height: self.height))
            }
            
            var rotatedImage: UIImage?
            switch self.positionType {
            case .auto:    rotatedImage = resizedImg!.rotate(radians: self.tattoo.rotation)
            case .manual:  rotatedImage = resizedImg!.rotate(radians: self.rotation)
            }
            
            let expandedSize = CGSize(width: defaultCanvasWidth, height: defaultCanvasHeight)
            
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
            
            //reset default position and tattoo types
            self.positionType = .auto
            self.tattoo.type = .new
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("UPDATED_DATA"), object: nil)
            }
        }
        
        
    }
    
    func commitTattoo(){
        print("Loading Image")
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
