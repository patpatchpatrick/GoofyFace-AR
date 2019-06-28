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
    
    var x: CGFloat = 400
    var y: CGFloat = 400
    var rotation: Float = 0
    
    public init(tattooModel: TattooModel) {
        self.tattoo = tattooModel
    }
    
    func loadImage(){
        
        print("Loading Image")
        DispatchQueue.global(qos: .background).async {
            guard let image = self.tattoo.image else {return}
            let resizedImg = resizeImage(image: image, targetSize: CGSize(width: self.tattoo.width, height: self.tattoo.height))
            //let rotatedImage = resizedImg.rotate(radians: self.tattoo.rotation)
            let rotatedImage = resizedImg.rotate(radians: self.rotation)
            let expandedSize = CGSize(width: defaultCanvasWidth, height: defaultCanvasHeight)
            //let currentCanvas = drawImageOnCanvas(rotatedImage!, canvas: self.canvas, canvasSize: expandedSize, x: self.tattoo.x, y: self.tattoo.y)
            let currentCanvas = drawImageOnCanvas(rotatedImage!, canvas: self.canvas, canvasSize: expandedSize, x: self.x, y: self.y)
            self.image = currentCanvas.alpha(0.8)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("UPDATED_DATA"), object: nil)
            }
        }
        
    }
    
    func commitTattoo(){
        print("Loading Image")
        DispatchQueue.global(qos: .background).async {
            guard let image = self.tattoo.image else {return}
            let resizedImg = resizeImage(image: image, targetSize: CGSize(width: self.tattoo.width, height: self.tattoo.height))
            let rotatedImage = resizedImg.rotate(radians: self.tattoo.rotation)
            let expandedSize = CGSize(width: defaultCanvasWidth, height: defaultCanvasHeight)
            self.canvas = drawImageOnCanvas(rotatedImage!, canvas: self.canvas, canvasSize: expandedSize, x: self.tattoo.x, y: self.tattoo.y)
            self.image = self.canvas?.alpha(0.8)
            
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
