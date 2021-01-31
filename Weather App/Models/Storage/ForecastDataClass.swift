//
//  ForecastDataClass.swift
//  yandexWeather
//
//  Created by Георгий iMac on 20.01.2021.
//

import RealmSwift

class ForecastData: Object {
    @objc dynamic var weekDay: String = "фторник"
    @objc dynamic var condition: String = "Халадна"
    @objc dynamic var dayTemperature: Int = -113
    @objc dynamic var nightTemperature: Int = +100
    @objc dynamic var weatherImageURL: String = "https://yastatic.net/weather/i/icons/blueye/color/svg/bkn_n.svg"
}
