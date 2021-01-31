//
//  StorageManager.swift
//  yandexWeather
//
//  Created by Георгий iMac on 18.01.2021.
//

import RealmSwift

let realm = try! Realm()
class StorageManager {
    
    static func saveWeatherData (weatherData: WeatherData) {
        try! realm.write { realm.add(weatherData,update: .modified)
        }
    } 
}
