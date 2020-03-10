//
//  CurrentWeather.swift
//  Weather
//
//  Created by Mario Zarate Velasquez on 3/3/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    private var _city: String!
    private var _date: Date!
    private var _currentTemp: Double!
    private var _feelsLike: Double!
    private var _uv: Double!
    
    private var _weatherType: String!
    private var _pressure: Double!
    private var _humidity: Double!
    private var _windSpeed: Double!
    private var _weatherIcon: String!
    private var _visibility: Double!
    private var _sunrise: String!
    private var _sunset: String!
    
    var city: String {
        if _city == nil {
            _city = ""
        }
        return _city
    }
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var currentTmp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    var feelsLike: Double {
        if _feelsLike == nil {
            _feelsLike = 0.0
        }
        return _feelsLike
    }
    
    var uv: Double {
        if _uv == nil {
            _uv = 0.0
        }
        return _uv
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var pressure: Double {
        if _pressure == nil {
            _pressure = 0.0
        }
        return _pressure
    }
    
    var humidity: Double {
        if _humidity == nil {
            _humidity = 0.0
        }
        return _humidity
    }
    
    var windSpeed: Double {
        if _windSpeed == nil {
            _windSpeed = 0.0
        }
        return _windSpeed
    }
    
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    var visibility: Double {
        if _visibility == nil {
            _visibility = 0.0
        }
        return _visibility
    }
    
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    
    var sunset: String {
        if _sunset == nil {
            _sunset = ""
        }
        return _sunset
    }
    
    func getCurrentWeather(location: WeatherLocation, completion: @escaping(_ success: Bool)->Void) {
        
        var LOCATIONAPI_URL: String!
        
        if !location.isCurrentLocation {
            LOCATIONAPI_URL = String(format: "https://api.weatherbit.io/v2.0/current?city=%@,%@&key=40f7f0d73eba4b1c9e7f69ce211612c2", location.city, location.countryCode)
        } else {
            LOCATIONAPI_URL = CURRENTLOCATION_URL
        }
        
        Alamofire.request(LOCATIONAPI_URL).responseJSON { (response) in
            let result = response.result
            if result.isSuccess {
                let json = JSON(result.value)
                let data = json["data"][0]
                self._city = data["city_name"].stringValue
                self._date = currentDateFromUnix(unixDate: data["ts"].double)
                self._weatherType = data["weather"]["description"].stringValue
                self._currentTemp = getTempBasedOnSettings(celsius: data["temp"].double ?? 0.0)
                self._feelsLike = getTempBasedOnSettings(celsius: data["app_temp"].double ?? 0.0)
                self._pressure = data["pres"].double
                self._humidity = data["rh"].double
                self._windSpeed = data["wind_spd"].double
                self._weatherIcon = data["weather"]["icon"].stringValue
                self._visibility = data["vis"].double
                self._uv = data["uv"].double
                self._sunrise = data["sunrise"].stringValue
                self._sunset = data["sunset"].stringValue
                
                completion(true)
            } else {
                self._city = location.city
                completion(false)
                print("no result found for current location")
            }
        }
        
    }
}
