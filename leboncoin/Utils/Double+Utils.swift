//
//  Double+Utils.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 25/06/2023.
//

import Foundation

extension Double {
    var formatPrice: String {
        String(format: "%.02f €", self).replacingOccurrences(of: ".", with: ",")
    }
}
