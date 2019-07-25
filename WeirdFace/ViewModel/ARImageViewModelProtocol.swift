//
//  TattooViewModelProtocol.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/13/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation

protocol ARImageViewModelViewDelegate: class
{
    func arImagePositionUpdated()
    func arImagePositionAccepted()
    func manualDrawingAccepted()
    func uploadedImageAccepted()
    func fullScreenDrawingAccepted()
    func resetARViews()
    func customImageChanged()
    func selectDefaultSize()
    func fullScreenDrawingDiscarded()
    func acceptImageSize()
    
}


protocol ARImageViewModelProtocol
{
    var model: ARImageModel { get set }
    var viewDelegate: ARImageViewModelViewDelegate { get set }
    
}
