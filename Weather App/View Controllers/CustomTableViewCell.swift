//
//  CustomTableViewCell.swift
//  yandexWeather
//
//  Created by Георгий iMac on 08.01.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherImage: CustomImageView!
    @IBOutlet weak var weekDayLable: UILabel!
    @IBOutlet weak var conditionLable: UILabel!
    @IBOutlet weak var dayTempLable: UILabel!
    @IBOutlet weak var nightTempLable: UILabel!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    func commonInit(imageURL: String,weekDay: String, condition: String, dayTemp: Int, nightTemp: Int) {

        
        
        weatherImage.loadImageUsingUrlString(urlString: imageURL)
        weekDayLable.text   = weekDay
        dayTempLable.text   = String(dayTemp)
        nightTempLable.text = String(nightTemp)
        conditionLable.text = condition
    }
}
