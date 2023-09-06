//
//  WeatherDatas.swift
//  task4_app
//
//  Created by Recep Uyduran on 1.09.2023.
//

import Foundation

struct OpenWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let timezone, id, cod: Int
    let name: String
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let temp, temp_min, temp_max: Double
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}
