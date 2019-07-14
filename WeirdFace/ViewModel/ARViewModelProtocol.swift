//
//  TattooViewModelProtocol.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/13/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation

protocol ARViewModelViewDelegate: class
{
    func arImagePositionUpdated()
    func arImagePositionAccepted()
    func manualDrawingAccepted()
    func uploadedImageAccepted()
    func fullScreenDrawingAccepted()
    func resetARViews()
    
}


protocol ARViewModelProtocol
{
    var model: ARModel { get set }
    var viewDelegate: ARViewModelViewDelegate { get set }
    
}
