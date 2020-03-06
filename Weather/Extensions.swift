//
//  Extensions.swift
//  Weather
//
//  Created by Mario Zarate Velasquez on 3/5/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import Foundation

extension Date {
    func shortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
}
