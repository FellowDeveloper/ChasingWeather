//
//  WeatherDataController.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/21/23.
//

import Foundation

class WeatherDataController {
    
    var reports: [NamedWeatherReport] {
        get {
            storage.storedReports()
        }
    }
    
    let fetcher: OpenWeatherAPIGateway
    let storage: WeatherStorage
    
    init(fetcher: OpenWeatherAPIGateway, storage: WeatherStorage) {
        self.fetcher = fetcher
        self.storage = storage
    }
    
    func getWeather(_ coordinate: Coordinate,
                    name: String,
                    completion: @escaping (NamedWeatherReport? ) -> ()) {
        fetcher.getWeather(coordinate, name: name) { [weak self] report, error  in
            
            if let report, let self = self {
                // Insert new report as first object to maintain array sorted by search date
                var reportsToSave = [report]
                reportsToSave.append(contentsOf: self.reports)
                self.storage.store(reportsToSave)
            }
            completion(report)
        }
    }
}
