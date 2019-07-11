//
//  CustomExtensions.swift
//  WeirdFace
//
//  Created by Patrick Doyle on 7/10/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import StoreKit

//Extension to help provide price string
extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
