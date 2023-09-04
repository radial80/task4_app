//
//  WeatherDatas.swift
//  task4_app
//
//  Created by Kasım Sağır on 1.09.2023.
//

import Foundation

struct OpenWeather: Codable {
    let lat: Double
    let lon: Double
    let tZone: String
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let name: String
}

