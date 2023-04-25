//
//  WeatherDataPersister.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/21/23.
//

import Foundation

// Candidate to be generic?
protocol DataPersister {
    
    func persist(reports: Array<NamedWeatherReport>)
    func persistedReports() -> Array<NamedWeatherReport>
}

struct WeatherDataPersister: DataPersister {
    func persistedReports() -> Array<NamedWeatherReport> {
        
        if let data = UserDefaults.standard.value(forKey: reportsKey) as? Data {
            let decoder = JSONDecoder()
            if let result = try? decoder.decode(Array<NamedWeatherReport>.self, from: data) {
                return result
            }
        }
        
        return []
        //UserDefaults.standard.value(forKey: reportsKey) as? Array<NamedWeatherReport> ?? []
    }
    
    func persist(reports: Array<NamedWeatherReport>) {
        let encoder = JSONEncoder()
        if let encodedReports = try? encoder.encode(reports) {
            UserDefaults.standard.set(encodedReports, forKey: reportsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private let reportsKey = "com.yourcompany.lol.reports"
}
