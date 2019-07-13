//
//  mainUIViewModelProtocol.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/13/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation

enum Mode{
    case select
    case draw
    case upload
    case position
    case place
}

protocol MainUIViewModelViewDelegate: class
{
    func modeChanged(to mode: Mode, _ viewModel: MainUIViewModel)


}


protocol MainUIViewModelProtocol
{
    var model: MainUIModel? { get set }
    var viewDelegate: MainUIViewModelViewDelegate? { get set }

}


