//
//  WeatherDataPersister.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/21/23.
//

import Foundation

// Candidate to be generic?
protocol WeatherStorage {
    
    func store(_ reports: Array<NamedWeatherReport>)
    func storedReports() -> Array<NamedWeatherReport>
}

struct UserDefaultsWeatherStorage: WeatherStorage {
    func storedReports() -> Array<NamedWeatherReport> {
        
        if let data = UserDefaults.standard.value(forKey: reportsKey) as? Data {
            let decoder = JSONDecoder()
            if let result = try? decoder.decode(Array<NamedWeatherReport>.self, from: data) {
                return result
            }
        }
        
        return []
    }
    
    func store(_ reports: Array<NamedWeatherReport>) {
        let encoder = JSONEncoder()
        if let encodedReports = try? encoder.encode(reports) {
            UserDefaults.standard.set(encodedReports, forKey: reportsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private let reportsKey = "com.yourcompany.lol.reports"
}
