//
//  WeatherManager.swift
//  Clima
//
//  Created by Sanil Sarathe on 10/01/24.

/* For Step to all API.
 1. Create URL.
 2. Create a URL session.
 3. Give the session a task.
 4. Start the task.
 */

import Foundation

protocol PassData: AnyObject {
    func didUpdateWeather(_ manager: WeatherManager, _ data: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=505e84b36ceb859a4ce9683bc4a2809c&units=metric"
    
    weak var delegate: PassData?
        
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if let safeError = error {
                    delegate?.didFailWithError(error: safeError)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weatherId = decodedData.weather.first?.id ?? 0
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: weatherId, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
