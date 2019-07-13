//
//  mainUIViewModel.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/13/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation

class MainUIViewModel : MainUIViewModelProtocol{
    
    var model: MainUIModel?
    var viewDelegate: MainUIViewModelViewDelegate?
    
    
    init(model: MainUIModel, delegate: MainUIViewModelViewDelegate ) {
        self.model = model
        self.viewDelegate = delegate
    }
    
    func modeChanged(mode: Mode){
        self.viewDelegate?.modeChanged(to: mode, self)
    }
    
    
}
