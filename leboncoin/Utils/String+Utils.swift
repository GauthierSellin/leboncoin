//
//  String+Utils.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 25/06/2023.
//

import Foundation

extension String {
    private static let dateFormatter: DateFormatter = {
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return $0
    }(DateFormatter())
    
    var formatDate: Date? {
        String.dateFormatter.date(from: self)
    }
}
