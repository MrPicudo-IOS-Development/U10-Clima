/* weatherManager.swift --> Clima. Created by Miguel Torres on 09/02/23. */

import Foundation

struct WeatherManager {
    // URL básica para la llamada a la API de OpenWeather.
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2efea90cc5e2995e5cd1d2ab8bd09bbc&units=metric"
    
    func fetchWeather(_ cityName: String) {
        // Unimos la URL básica de la llamada a la API de OpenWeather con el nombre de la ciudad que obtenemos del textField.
        let urlString = "\(weatherURL)&q=\(cityName)"
        // Imprimimos para verificar que la cadena de la URL se creó correctamente
        print(urlString)
    }
}
