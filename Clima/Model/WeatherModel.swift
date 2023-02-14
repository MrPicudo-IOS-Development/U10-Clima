/* WeatherModel.swift --> Clima. Created by Miguel Torres on 14/02/23. */

import Foundation

struct WeatherModel {
    
    // Store properties
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    // Computed properties
    var conditionName: String {
        switch(conditionId) {
        case 200...232:
            return "cloud.heavy.rain.circle"
        case 300...321:
            return "cloud.drizzle"
        case 500...504:
            return "cloud.rain.fill"
        case 511:
            return "snowflake"
        case 520...531:
            return "cloud.drizzle"
        case 600...622:
            return "snowflake"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max.fill"
        case 801:
            return "cloud.sun"
        case 802:
            return "cloud.sun.fill"
        case 803...804:
            return "cloud.sun.circle.fill"
        default:
            return "sun.max.fill"
        }
    }
    
}
