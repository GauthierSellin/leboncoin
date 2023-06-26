//
//  Date+Utils.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 25/06/2023.
//

import Foundation

extension Date {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
    
    var formatString: String {
        Date.dateFormatter.string(from: self)
    }
}
