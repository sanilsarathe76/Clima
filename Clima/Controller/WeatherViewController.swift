//
//  WeatherViewController.swift
//  Clima
//
//  Created by Sanil Sarathe on 10/01/24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    var coordinates = (CLLocationDegrees(), CLLocationDegrees())
    
    let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.requestLocation() // this will give us current location only one time.
        
        /*if we want updated location of user or car like navigation type of apps then we can use :-
        locationManger.startUpdatingLocation()*/
        weatherManager.delegate = self
        textField.delegate = self
        textField.placeholder = "Type something"
    }
    
    @IBAction func onClickSearch(_ sender: Any) {
        textField.endEditing(true)
    }
    
    @IBAction func onClickCurrentWeatherButton(_ sender: Any) {
        //when we requestLocation the didUpdateLocations method triggered.
        locationManger.requestLocation()
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            textField.text = ""
            weatherManager.fetchWeather(cityName: city)
        }
    }
    
    func setWeatherData(data: WeatherModel) {
        if let conditionName = data.conditionName {
            DispatchQueue.main.async {
                self.weatherImageView.image = UIImage(systemName: conditionName)
            }
        }
        
        if let temperatureString = data.temperatureString {
            DispatchQueue.main.async {
                self.temperatureLabel.text = "\(temperatureString) °C"
            }
        }
        
        if let cityName = data.cityName {
            DispatchQueue.main.async {
                self.cityLabel.text = cityName
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did Update location Called!!!")
        if let location = locations.last {
            locationManger.stopUpdatingLocation()
            coordinates.0 = location.coordinate.latitude
            coordinates.1 = location.coordinate.longitude
            weatherManager.fetchWeatherUsingLatLng(coordinates.0, coordinates.1)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Not able to get location", error)
    }
}

extension WeatherViewController: PassData {
    func didUpdateWeather(_ manager: WeatherManager, _ data: WeatherModel) {
        setWeatherData(data: data)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
