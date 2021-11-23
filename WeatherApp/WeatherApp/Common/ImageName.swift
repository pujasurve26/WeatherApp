//
//  ImageName.swift
//  WeatherApp
//
//  Created by Puja Kalpesh Surve on 23/11/21.
//

import UIKit


enum ImageName {
    case cloud
    case sun
    case rain

    var image: UIImage? {
        switch self {
            case .cloud: return UIImage(systemName: "cloud.bolt")
            case .sun: return UIImage(systemName: "cloud.sun")
            case .rain: return UIImage(systemName: "cloud.rain")
        }
    }
}
