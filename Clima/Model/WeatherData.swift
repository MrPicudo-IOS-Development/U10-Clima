/* weatherData.swift --> Clima. Created by Miguel Torres on 12/02/23. */

import Foundation

// Estructura que implementa el protocolo de saber decodificarse a si misma a partir de una representación externa como JSON
struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

// Estructura para el atributo main de la estructura principal
struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

// Creamos la estructura de la cual haremos un arreglo en la estructura principal
struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
