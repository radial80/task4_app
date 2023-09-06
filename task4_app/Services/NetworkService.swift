//
//  NetworkService.swift
//  task4_app
//
//  Created by Recep Uyduran on 1.09.2023.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()

    let URL_SAMPLE = "https://api.openweathermap.org/data/2.5/weather?lat=41.02&lon=29.01&appid=89575d3c850c4fe09a01e9aedf6aec9e"
    let URL_API_KEY = "abf74e886720efbfd7fa8e30e1a4f1e6"
    var URL_LATITUDE = "41.02"
    var URL_LONGITUDE = "29.01"
    var URL_GET_CALL = ""
    let URL_BASE = "https://api.openweathermap.org/data/2.5"

    let session = URLSession(configuration: .default)

    func buildURL() -> String {
        URL_GET_CALL = "/weather?lat=" + URL_LATITUDE + "&lon=" + URL_LONGITUDE + "&units=metric" + "&appid=" + URL_API_KEY
        return URL_BASE + URL_GET_CALL
    }

    func setLatitude(_ latitude: String) {
        URL_LATITUDE = latitude
    }

    func setLatitude(_ latitude: Double) {
        setLatitude(String(latitude))
    }

    func setLongitude(_ longitude: String) {
        URL_LONGITUDE = longitude
    }

    func setLongitude(_ longitude: Double) {
        setLongitude(String(longitude))
    }

    func getWeather(onSuccess: @escaping (OpenWeather) -> Void, onError: @escaping (String) -> Void) {
        guard let url = URL(string: buildURL()) else {
            onError("Error building URL")
            return
        }

        let task = session.dataTask(with: url) { (data, response, error) in

            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }

                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(OpenWeather.self, from: data)
                        onSuccess(items)
                    } else {
                        onError("Response wasn't 200. It was: " + "\n\(response.statusCode)")
                    }
                } catch {
                    onError(error.localizedDescription)
                }
            }

        }
        task.resume()
    }

}
