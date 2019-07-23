//
//  ARDistortionViewModelProtocol.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/22/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import UIKit

protocol ARDistortionViewModelViewDelegate: class
{
    func toggleSecondaryMenu(hidden: Bool)
    func toggleSecondarySizeSubMenu(hidden: Bool)
    func toggleSecondaryPositionSubMenu(hidden: Bool)
    func distortionButtonSelected(button: UIButton)
    func unselectFeatureButtons()
    func unselectPositionButtons()
    func unselectDistortionEditButtons()
    func collapseSecondaryMenuIfExpanded()
    func resetFeaturesSlider()
    func hideModeSelectMenu()
    func toggleModeSelectMenu()
    func toggleFeatureSlider(hidden: Bool)
}


protocol ARDistortionViewModelProtocol
{
    var model: ARDistortionModel { get set }
    var viewDelegate: ARDistortionViewModelViewDelegate { get set }
    
}
