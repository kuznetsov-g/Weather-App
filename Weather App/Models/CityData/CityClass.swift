//
//  CityData.swift
//  Weather App
//
//  Created by Георгий iMac on 30.01.2021.
//

import Foundation
import Alamofire

protocol CityDataDelegate: class {
    func getCityData (cityCoordinateLat: String, cityCoordinateLong: String, currentCityName: String, haveData: Bool)
}

class City {
    let searchName         : String!
    var cityCoordinateLat  = "0.0"
    var cityCoordinateLong = "0.0"
    var currentCityName    = "City Name"
    
    weak var cityDataDelegate: CityDataDelegate!
    
    init (serachName: String, delegate: CityDataDelegate) {
        self.searchName       = serachName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        self.cityDataDelegate = delegate
        getCityData()
    }
    
    private func getCityData() {
        let apiKey = "23828a58-4738-4bac-8372-18ad369a78d7"
        let geoURL = "https://geocode-maps.yandex.ru/1.x/?format=json&apikey="+apiKey+"&geocode="+searchName+"&results=1"
        
        AF.request(geoURL).responseData { (responseJSON) in
            switch responseJSON.result {
                case .success(let value):
                    do { let cityData = try JSONDecoder().decode(CityJSON.self, from: value)
                         let selfData = cityData.response.GeoObjectCollection.metaDataProperty.GeocoderResponseMetaData
                            if selfData.found == "0" {
                                self.cityDataDelegate.getCityData(cityCoordinateLat : self.cityCoordinateLat,
                                                                  cityCoordinateLong: self.cityCoordinateLong,
                                                                  currentCityName   : selfData.request,
                                                                  haveData          : false
                                                                 )
                                } else {
                                    let cityDetails = cityData.response.GeoObjectCollection.featureMember[0].GeoObject
                                    self.currentCityName = cityDetails.metaDataProperty.GeocoderMetaData.Address.Components[4].name
                                    self.getCityCoordinates(cityDetails.Point.pos)
                                    print("current position", cityDetails.Point.pos)
                                        }
                    } catch let error { print ("error while fetching geocoder data",error)}
                case .failure(let error):
                print("error while fetching geocoder data",error)
            }
        }
    }
    
    private func getCityCoordinates(_ cityCoordinates: String) -> () {
        let coordinatesArray = cityCoordinates.components(separatedBy: " ")
        self.cityCoordinateLong = coordinatesArray[0]
        self.cityCoordinateLat  = coordinatesArray[1]
        sendData()
}
    private func sendData () {
        self.cityDataDelegate.getCityData(cityCoordinateLat : self.cityCoordinateLat,
                                          cityCoordinateLong: self.cityCoordinateLong,
                                          currentCityName   : self.currentCityName,
                                          haveData          : false
                                         )
    }
}
