//
//  DataStructures.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/5/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import UIKit

struct ShapeLayerStack {
    //Stack to keep track of shape layers when user is drawing an image
    fileprivate var array: [CAShapeLayer] = []
    
    mutating func push(_ element: CAShapeLayer) {
        array.append(element)
    }
    
    mutating func pop() -> CAShapeLayer? {
        return array.popLast()
    }

    func peek() -> CAShapeLayer? {
        return array.last
    }
    
    mutating func clear() {
        array.removeAll()
    }
    
    func resetAllShapePaths() {
        let path = UIBezierPath()
        path.removeAllPoints()
        for shape in array {
            shape.path = path.cgPath
        }
    }

}

struct PathStack {
    //Stack to keep track of paths when user is drawing an image
    fileprivate var array: [UIBezierPath] = []
    
    mutating func push(_ element: UIBezierPath) {
        array.append(element)
    }
    
    mutating func pop() -> UIBezierPath? {
        return array.popLast()
    }
    
    func peek() -> UIBezierPath? {
        return array.last
    }
    
    mutating func clear() {
        array.removeAll()
    }
    
    func removePointsFromAll() {
        //Remove points from all paths
        for path in array {
            path.removeAllPoints()
        }
    }
    
}
