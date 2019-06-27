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
    
    public init(tattooModel: TattooModel) {
        self.tattoo = tattooModel
    }
    
    func loadImage(){
        
        print("Loading Image")
        DispatchQueue.global(qos: .background).async {
            guard let image = self.tattoo.image else {return}
            let resizedImg = resizeImage(image: image, targetSize: CGSize(width: self.tattoo.width, height: self.tattoo.height))
            let rotatedImage = resizedImg.rotate(radians: self.tattoo.rotation)
            let expandedSize = CGSize(width: defaultCanvasWidth, height: defaultCanvasHeight)
            let uiImage = drawImageOnCanvas(rotatedImage!, canvasSize: expandedSize, canvasColor: .clear, x: self.tattoo.x, y: self.tattoo.y)
            self.image = uiImage.alpha(0.8)
            
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
    
}
