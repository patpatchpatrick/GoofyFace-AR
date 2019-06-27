//
//  ImageExtensions.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 6/26/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import UIKit
import VideoToolbox

func drawImageOnCanvas(_ useImage: UIImage, canvasSize: CGSize, canvasColor: UIColor, x: CGFloat, y: CGFloat ) -> UIImage {
    
    let rect = CGRect(origin: .zero, size: canvasSize)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    
    var xPos = x
    var yPos = y
    
    // fill the entire image
    canvasColor.setFill()
    UIRectFill(rect)
    
    if xPos < 0 {
        xPos = 0
    }
    if yPos < 0 {
        yPos = 0
    }
    if xPos + useImage.size.width > 1000 {
        xPos = 1000 - useImage.size.width
    }
    if yPos + useImage.size.height > 1000 {
        yPos = 1000 - useImage.size.height
    }

    // calculate a Rect the size of the image to draw, centered in the canvas rect
    let centeredImageRect = CGRect(x: xPos,
                                   y: yPos,
                                   width: useImage.size.width,
                                   height: useImage.size.height)
    
    // get a drawing context
    let context = UIGraphicsGetCurrentContext();
    
    // "cut" a transparent rectangle in the middle of the "canvas" image
    context?.clear(centeredImageRect)
    
    // draw the image into that rect
    useImage.draw(in: centeredImageRect)
    
    // get the new "image in the center of a canvas image"
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
    
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}


