//
//  GlobalHelpers.swift
//  Weather
//
//  Created by Mario Zarate Velasquez on 3/3/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import Foundation

func currentDateFromUnix(unixDate: Double?) ->Date {
    if unixDate != nil {
        return Date(timeIntervalSince1970: unixDate!)
    } else {
        return Date()
    }
}
