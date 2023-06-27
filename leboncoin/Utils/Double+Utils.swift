//
//  Double+Utils.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 25/06/2023.
//

import Foundation

extension Double {
    private static let numberFormatter: NumberFormatter = {
        $0.numberStyle = .currency
        $0.locale = Locale(identifier: "fr_FR")
        return $0
    }(NumberFormatter())
    
    var formatPrice: String {
        Double.numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
