//
//  LocationService.swift
//  Weather
//
//  Created by Pedro on 3/10/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import Foundation

class LocationService {
    static var shared = LocationService()
    var longitude: Double!
    var latitude: Double!
}
