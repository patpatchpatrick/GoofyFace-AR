//
//  ARDistortionViewModelProtocol.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/22/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation

protocol ARDistortionViewModelViewDelegate: class
{
    func toggleSecondaryMenu(hidden: Bool)
    func toggleSecondarySizeSubMenu(hidden: Bool)
    func toggleSecondaryPositionSubMenu(hidden: Bool)
}


protocol ARDistortionViewModelProtocol
{
    var model: ARDistortionModel { get set }
    var viewDelegate: ARDistortionViewModelViewDelegate { get set }
    
}
