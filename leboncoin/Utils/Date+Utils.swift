//
//  Date+Utils.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 25/06/2023.
//

import Foundation

extension Date {
    private static let dateFormatter: DateFormatter = {
        $0.dateStyle = .medium
        $0.locale = Locale(identifier: "fr_FR")
        return $0
    }(DateFormatter())
    
    var formatString: String {
        Date.dateFormatter.string(from: self)
    }
}
