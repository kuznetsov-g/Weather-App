//
//  getJSON.swift
//  yandexWeather
//
//  Created by metahdev on 16/01/2021
//

import UIKit
import Alamofire
import SVGKit

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    var imageUrlString: String?
    private var alamofireManager: Session?
    
    func loadImageUsingUrlString(urlString: String){
        imageUrlString = urlString
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        let url = URL(string: urlString)!
        AF.request(url).responseData {(response) in
            guard response.error == nil else {return}
            if let data = response.data {
                DispatchQueue.main.async {
                    guard let imageSVG = SVGKImage(data: data) else { return }
                        let imageToCache = imageSVG.uiImage
                        if self.imageUrlString == urlString {
                            self.image = imageToCache
                        }
                    imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                }
            }
        }
    }
}
