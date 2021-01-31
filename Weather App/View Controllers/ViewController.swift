//
//  ViewController.swift
//  Weather App
//
//  Created by Георгий iMac on 30.01.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
  
    

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentConditionImage: CustomImageView!
    @IBOutlet weak var forecastTable: UITableView!
    @IBOutlet weak var cityCollection: UICollectionView!
    
    var indexCity : Int!
    var cityIDArray : [Int] = []
    
   
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        let addCityVC = segue.source as! AddCityViewController
        addCity(cityName: addCityVC.textData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddCityVC" {
            let _ = segue.destination as! AddCityViewController
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastTable.delegate = self
        forecastTable.dataSource = self
        forecastTable.tableFooterView = UIView()
        
        cityCollection.delegate = self
        cityCollection.dataSource = self
        
        
        if realm.objects(WeatherData.self).count != 0 {
            for x in 0...realm.objects(WeatherData.self).count-1 {
                if realm.objects(WeatherData.self)[x].isSelected {
                    indexCity = x
                }
            }
            let weatherData = realm.objects(WeatherData.self)[indexCity]
            cityNameLabel.text = weatherData.cityName
            currentTempLabel.text = String(weatherData.currentTemperature)+" °C"
            currentConditionImage.loadImageUsingUrlString(urlString: weatherData.currentWeatherimageURL)
        } else {
            cityNameLabel.text = "Привет"
            currentTempLabel.text = "t °C"
            currentConditionImage.loadImageUsingUrlString(urlString: "https://yastatic.net/weather/i/icons/blueye/color/svg/ovc_-ra.svg")
        }
        
        let nibTable = UINib.init(nibName: "CustomTableViewCell", bundle: nil)
        forecastTable.register(nibTable, forCellReuseIdentifier: "customCell")
        
        let nibCollection = UINib.init(nibName: "CustomCollectionViewCell", bundle: nil)
        cityCollection.register(nibCollection, forCellWithReuseIdentifier: "customCollectionCell")
        
        let nibPlus = UINib.init(nibName: "AddCityViewCell", bundle: nil)
        cityCollection.register(nibPlus, forCellWithReuseIdentifier: "addCityCell")
    }


}


extension ViewController {
    func addCity(cityName: String) {
    let _ = Weather(searchName: cityName, delegate: self)
    }
}


extension ViewController: WeatherDelegate {
    func getWeather(selectedCityID: Int, searchName: String, haveData: Bool) {
        if haveData {
            for x in 0...realm.objects(WeatherData.self).count {
                if realm.objects(WeatherData.self)[x].cityID == selectedCityID {
                    indexCity = x
                }
                cityIDArray += [realm.objects(WeatherData.self).sorted(byKeyPath: "cityID")[x].cityID]
            }
            let weatherData = realm.objects(WeatherData.self)[indexCity]
            cityNameLabel.text = weatherData.cityName
            currentTempLabel.text = String(weatherData.currentTemperature)+" °C"
            currentConditionImage.loadImageUsingUrlString(urlString: weatherData.currentWeatherimageURL)
            
        } else {
            self.showAlert(title: "Крупная ошибка", message: "города с именем \(searchName) нет")
        }
    }
}


extension ViewController {
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(          title: title
                                             ,message: message
                                      ,preferredStyle: .alert )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = realm.objects(WeatherData.self).last else {return 0}
        return realm.objects(WeatherData.self)[indexCity].forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomTableViewCell
          let forecastCell = realm.objects(WeatherData.self)[indexCity].forecasts[indexPath.row]
            let imageURL   = forecastCell.weatherImageURL
            let weekDay    = forecastCell.weekDay
            let condition  = forecastCell.condition
            let dayTemp    = forecastCell.dayTemperature
            let nightTemp  = forecastCell.nightTemperature
        cell?.commonInit(imageURL : imageURL,
                         weekDay  : weekDay,
                         condition: condition,
                         dayTemp  : dayTemp,
                         nightTemp: nightTemp)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 50
   }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let _ = realm.objects(WeatherData.self).last else {return 1}
        return realm.objects(WeatherData.self).count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionCell", for: indexPath) as! CustomCollectionViewCell
            let dataForCell = realm.objects(WeatherData.self)[cityIDArray[indexPath.row]]
            cell.commonInit(    iconURL:        dataForCell.currentWeatherimageURL
                              ,cityName:        dataForCell.cityName
                           ,currentTemp: String(dataForCell.currentTemperature)+"°C")
            cell.layer.cornerRadius = 16
            return cell
        } else {
            let plusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCityCell", for: indexPath) as! AddCityViewCell
                plusCell.plus.backgroundColor?.withAlphaComponent(0.6)
                plusCell.plusView.backgroundColor?.withAlphaComponent(0.7)
                plusCell.layer.cornerRadius = 16
                plusCell.plus.layer.cornerRadius = 12
                plusCell.plus.layer.masksToBounds = true
            return plusCell
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {

            addCity(cityName: realm.objects(WeatherData.self)[cityIDArray[indexPath.row]].cityName)
            print("вызвали город с именем ",realm.objects(WeatherData.self)[cityIDArray[indexPath.row]].cityName)
        } else {
            performSegue(withIdentifier: "showAddCityVC", sender: cityCollection)
        }
        print("indexpath.row",indexPath.row)
    }
}
