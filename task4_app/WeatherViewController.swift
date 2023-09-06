//
//  ViewController.swift
//  task4_app
//
//  Created by Recep Uyduran on 1.09.2023.
//

import UIKit
import MapKit
import Kingfisher

class WeatherViewController: UIViewController {
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var currenTemperatureLabel: UILabel!
    @IBOutlet private weak var maxMinTemperature: UILabel!

    private var city = ""
    private var weatherResult: OpenWeather?
    private var locationManger: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clearAll()
        getLocation()
    }

    private func clearAll() {
        cityLabel.text = ""
        weatherImageView.image = nil
        currenTemperatureLabel.text = ""
        maxMinTemperature.text = ""
    }

    private func getLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManger = CLLocationManager()
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyBest
            locationManger.requestWhenInUseAuthorization()
            locationManger.requestLocation()
        }
    }

    private func getWeather() {
        NetworkService.shared.getWeather(onSuccess: { (result) in
            self.updateView(with: result)
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }

    private func updateView(with model: OpenWeather) {
        cityLabel.text = city

        let iconName = model.weather.first?.icon ?? ""
        let imageUrl = "https://openweathermap.org/img/wn/" + iconName + "@2x.png"
        let url = URL(string: imageUrl)
        weatherImageView.kf.setImage(with: url)

        currenTemperatureLabel.text = "\(Int((model.main.temp.rounded())))°C"

        let maxValue = "Max: " + "\(Int((model.main.temp_max.rounded())))°C"
        let minValue = "Min: " + "\(Int((model.main.temp_min.rounded())))°C"
        maxMinTemperature.text = maxValue + " " + minValue

    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            let latitude: Double = location.coordinate.latitude
            let longitude: Double = location.coordinate.longitude

            NetworkService.shared.setLatitude(latitude)
            NetworkService.shared.setLongitude(longitude)

            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
                if let placemarks = placemarks,
                   let placemark = placemarks.first,
                   let city = placemark.locality {
                    self.city = city
                }
            }
            getWeather()
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        debugPrint(error.localizedDescription)
    }
}
