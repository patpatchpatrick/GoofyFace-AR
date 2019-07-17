//
//  TattooModel.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 6/27/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import UIKit


protocol Printable {
    var description: String { get }
}

//Total count of tattoo images user can select from
//Images are numbered, and this number is used to load them
let totalImageCount: Int = 62

enum ARPickerType {
    case position
    case size
}

enum FacialPosition: Int, Printable, CaseIterable {
    case leftBrow = 1
    case forehead = 2
    case rightBrow = 3
    case leftCheek = 4
    case nose = 5
    case rightCheek = 6
    case lowerLip = 7
    case new = 8
    
    var description: String {
        switch self {
        case .leftBrow: return "1"
        case .forehead: return "2"
        case .rightBrow: return "3"
        case .leftCheek   : return "4"
        case .nose : return "5"
        case .rightCheek : return "6"
        case .lowerLip: return "7"
        case .new:
            return "8"
        }
    }
}

enum ARImageSize: Int, Printable, CaseIterable {
    case small = 1
    case medium = 2
    case large = 3

    
    var description: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
}

public class ARModel {
    var image: UIImage?
    var imageName: String {
        didSet {
            self.image = UIImage(named: imageName)
        }
    }
    
    var defaultXPosition:CGFloat = 400
    var defaultYPosition:CGFloat = 400
    var defaultWidth:CGFloat = 200
    var defaultHeight:CGFloat = 100
    var defaultRotation:Float = 0
    
    var type: FacialPosition {
        didSet {
            updateDimensions()
        }
    }
    var width: CGFloat
    var height: CGFloat
    var x: CGFloat
    var y: CGFloat
    var rotation: Float
    
    init(
                imageName: String, tattooType: FacialPosition) {
        self.imageName = imageName
        self.image = UIImage(named: imageName)
        self.type = tattooType
        switch type {
        case .lowerLip:
            self.x = 400
            self.y = 692
            self.rotation = 0
            self.width = 200
            self.height = 100
        case .leftCheek:
            self.x = 142
            self.y = 380
            self.rotation = 0.436332
            self.width = 200
            self.height = 100
        case .forehead:
            self.x = 398
            self.y = 52
            self.rotation = 0
            self.width = 200
            self.height = 100
        case .leftBrow:
            self.x = 144
            self.y = 60
            self.rotation = -0.39444
            self.width = 200
            self.height = 100
        case .rightBrow:
            self.x = 666
            self.y = 54
            self.rotation = 0.39444
            self.width = 200
            self.height = 100
        case .nose:
            self.x = 450
            self.y = 292
            self.rotation = 1.5708
            self.width = 200
            self.height = 100
        case .rightCheek:
            self.x = 630
            self.y = 388
            self.rotation = -0.436332
            self.width = 200
            self.height = 100
        case .new:
            self.x = 398
            self.y = 155
            self.rotation = 0
            self.width = 200
            self.height = 100
        }
    }
    
    func updateDimensions(){
        switch type {
        case .lowerLip:
            self.x = 400
            self.y = 692
            self.rotation = 0
            self.width = 200
            self.height = 100
        case .leftCheek:
            self.x = 142
            self.y = 380
            self.rotation = 0.436332
            self.width = 200
            self.height = 100
        case .forehead:
            self.x = 398
            self.y = 52
            self.rotation = 0
            self.width = 200
            self.height = 100
        case .leftBrow:
            self.x = 144
            self.y = 60
            self.rotation = -0.39444
            self.width = 200
            self.height = 100
        case .rightBrow:
            self.x = 666
            self.y = 54
            self.rotation = 0.39444
            self.width = 200
            self.height = 100
        case .nose:
            self.x = 450
            self.y = 292
            self.rotation = 1.5708
            self.width = 200
            self.height = 100
        case .rightCheek:
            self.x = 630
            self.y = 388
            self.rotation = -0.436332
            self.width = 200
            self.height = 100
        case .new:
            self.x = 398
            self.y = 155
            self.rotation = 0
            self.width = 200
            self.height = 100
        }
    }
    
}




