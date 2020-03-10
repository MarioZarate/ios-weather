//
//  APIURLS.swift
//  Weather
//
//  Created by Mario Zarate Velasquez on 3/8/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import Foundation

let CURRENTLOCATION_URL = "https://api.weatherbit.io/v2.0/current?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&key=40f7f0d73eba4b1c9e7f69ce211612c2"

let CURRENTLOCATIONWEEKLYFORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/daily?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&days=7&key=40f7f0d73eba4b1c9e7f69ce211612c2"

let CURRENTLOCATIONHOURLYFORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&hours=24&key=40f7f0d73eba4b1c9e7f69ce211612c2"
