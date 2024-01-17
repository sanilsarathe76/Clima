//
//  WeatherViewController.swift
//  Clima
//
//  Created by Sanil Sarathe on 10/01/24.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var manager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        textField.delegate = self
        textField.placeholder = "Type something"
    }
    
    @IBAction func onClickSearch(_ sender: Any) {
        textField.endEditing(true)
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
            manager.fetchWeather(cityName: city)
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
                self.temperatureLabel.text = temperatureString
            }
        }
        
        if let cityName = data.cityName {
            DispatchQueue.main.async {
                self.cityLabel.text = cityName
            }
        }
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
