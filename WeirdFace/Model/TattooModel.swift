//
//  TattooModel.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 6/27/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import UIKit

public class TattooModel {
    public let image: UIImage
    let position: Int
    var width: CGFloat
    var height: CGFloat
    var x: CGFloat
    var y: CGFloat
    var rotation: CGFloat
    
    public init(name: String,
                image: UIImage, width: CGFloat, height: CGFloat, position: Int) {
        self.image = image
        self.width = width
        self.height = height
        self.position = position
        switch position {
        default:
            self.x = 0
            self.y = 0
            self.rotation = 0
        }
    }
}
