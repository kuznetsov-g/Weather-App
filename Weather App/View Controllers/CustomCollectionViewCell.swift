//
//  UICollectionViewCell.swift
//  yandexWeather
//
//  Created by Георгий iMac on 09.01.2021.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var currentWeatherImage: CustomImageView!
    @IBOutlet weak var cityNameLable: UILabel!
    @IBOutlet weak var currentTempLable: UILabel!
    @IBOutlet weak var customView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func commonInit(iconURL: String, cityName: String, currentTemp: String) {
        self.currentWeatherImage.loadImageUsingUrlString(urlString: iconURL)
        self.cityNameLable.text = cityName
        self.currentTempLable.text = currentTemp
    }
}



    
     

