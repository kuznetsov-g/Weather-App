//
//  GetWeatherData.swift
//  Weather App
//
//  Created by Георгий iMac on 30.01.2021.
//

import Alamofire
import Foundation
import SVGKit
import RealmSwift

protocol WeatherDelegate: class{
    func getWeather(selectedCityID: Int, searchName: String, haveData: Bool)
}

class Weather: CityDataDelegate, WeatherJSONDelegate {
    let searchName         : String!
//    var cityData           : City!
    var selectedCityID     : Int!
    var haveData           : Bool = true
    var cityCoordinateLat  : String!
    var cityCoordinateLong : String!
    var currentCityName    : String!
    
    
    weak var weatherDelegate: WeatherDelegate!
    
    init (searchName: String, delegate: WeatherDelegate) {
        self.searchName = searchName
        let _ = City(serachName: searchName, delegate: self)
        self.weatherDelegate = delegate
    }
    
    func getCityData(cityCoordinateLat: String, cityCoordinateLong: String, currentCityName: String, haveData: Bool) {
        if haveData {
            self.cityCoordinateLat  = cityCoordinateLat
            self.cityCoordinateLong = cityCoordinateLong
            self.currentCityName    = currentCityName
            print("loading date of city \(currentCityName) is correct")
        let timestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
            print("current time is ",timestamp)
        if realm.objects(WeatherData.self).count > 0 {
            var cityNamesArray: [String] = []
            for x in 0...realm.objects(WeatherData.self).count-1 {
                cityNamesArray += [realm.objects(WeatherData.self)[x].cityName]
            }
            guard let objectIndex = cityNamesArray.firstIndex(of: self.currentCityName)
            else {let _ = WeatherJSON(lat: self.cityCoordinateLat,
                                      lon: self.cityCoordinateLong,
                                      cityID: cityNamesArray.count,
                                      delegate: self)
                self.selectedCityID = cityNamesArray.count
                  return}
            if Int(truncating: timestamp) - realm.objects(WeatherData.self)[objectIndex].updateTime > 300 {
                let _ = WeatherJSON(lat: self.cityCoordinateLat,
                                    lon: self.cityCoordinateLong,
                                    cityID: realm.objects(WeatherData.self)[objectIndex].cityID,
                                    delegate: self)
                self.selectedCityID = realm.objects(WeatherData.self)[objectIndex].cityID
            } else {
                self.selectedCityID = realm.objects(WeatherData.self)[objectIndex].cityID
            }
        } else {
            let _ = WeatherJSON(lat: self.cityCoordinateLat,
                                lon: self.cityCoordinateLong,
                                cityID: 0,
                                delegate: self)
            self.selectedCityID = 0
        }
        } else {
            self.haveData = false
            self.selectedCityID = -1
        }
    }
    
    
    func updateWeatherData(weatherData: WeatherData) {
        StorageManager.saveWeatherData(weatherData: weatherData)
        sendDataToMainView()
    }
    
    
    func sendDataToMainView() {
        self.weatherDelegate.getWeather(selectedCityID: selectedCityID,
                                        searchName: searchName,
                                        haveData: haveData)
    }
    
    }

