//
//  gradientView.swift
//  yandexWeather
//
//  Created by Георгий iMac on 09.01.2021.
//

import Foundation
import UIKit

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [UIColor.darkGray.cgColor, UIColor.gray.cgColor,  UIColor.systemPurple.cgColor]
    }
}
