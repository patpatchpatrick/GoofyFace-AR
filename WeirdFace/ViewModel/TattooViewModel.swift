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
    
    public init(tattooModel: TattooModel) {
        self.tattoo = tattooModel
    }
    
    func loadImage(){
        guard let image = tattoo.image else {return}
        let resizedImg = resizeImage(image: image, targetSize: CGSize(width: tattoo.width, height: tattoo.height))
        let expandedSize = CGSize(width: defaultCanvasWidth, height: defaultCanvasHeight)
        let imageOnCanvas = drawImageOnCanvas(resizedImg, canvasSize: expandedSize, canvasColor: .clear, x: tattoo.x, y: tattoo.y)
        
    }
    
}
