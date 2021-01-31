//
//  AddCityViewController.swift
//  yandexWeather
//
//  Created by Георгий iMac on 10.01.2021.
//

import UIKit

class AddCityViewController: UIViewController {
    @IBOutlet weak var addCityLine: UITextField!

    var textData: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        addCityLine.delegate = self

    }
    
    @IBAction func addCityAction(_ sender: Any){
        self.textData = addCityLine.text!
    }
    
  
}

extension AddCityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       addCityLine.resignFirstResponder()
    return true
    }
    
    
}
