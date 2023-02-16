/* weatherData.swift --> Clima. Created by Miguel Torres on 12/02/23. */

import Foundation

// Estructura que implementa el protocolo de saber decodificarse a si misma a partir de una representación externa como JSON
struct WeatherData: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

// Estructura para crear objetos de tipo Coord en la estructura principal
struct Coord: Codable {
    let lon: Double
    let lat: Double
}

// Estructura con la cual haremos un arreglo de objetos tipo Weather en la estructura principal.
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// Estructura para el atributo main de la estructura principal
struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

// Estructura para crear objetos de tipo Wind en la estructura principal
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

// Estructua para crear objetos de tipo Clouds en la estructura principal
struct Clouds: Codable {
    let all: Int
}

// Estructura para crear objetos de tipo Sys en la estructura principal
struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}
