//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by kerik on 16.07.2024.
//

import UIKit

struct WeatherModel {
    let icon: UIImage
    let description: String
    let weatherType: WeatherType
    let animationSetup: (UIView) -> Void
}

enum WeatherType {
    case sunny
    case rainy
    case stormy
    case foggy
}
