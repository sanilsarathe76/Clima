//
//  WeatherData.swift
//  Clima
//
//  Created by Sanil Sarathe on 11/01/24.
//

import Foundation

enum WeatherCondition: String {
    case FOG = "cloud"
    case CloudRain = "cloud.rain"
    case CloudRainFill = "cloud.rain.fill"
    case CloudHeavyRainFill = "cloud.heavyrain.fill"
    case CloudHeavyRain = "cloud.heavyrain"
    case CloudFog = "cloud.fog"
    case CloudFogFill = "cloud.fog.fill"
}

struct WeatherData: Codable {
    let name: String
    let base: String
    let coord: LatLng
    let weather: [Weather]
    let main: MainObj
}

struct MainObj: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Int
}

struct LatLng: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
