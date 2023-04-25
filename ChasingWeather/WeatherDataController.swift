//
//  WeatherDataController.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/21/23.
//

import Foundation

class WeatherDataController {
    
    @Published var reports: Array<NamedWeatherReport>
    
    let fetcher: OpenWeatherAPIGateway
    let persister: DataPersister
    
    init(fetcher: OpenWeatherAPIGateway, persister: DataPersister) {
        self.fetcher = fetcher
        self.persister = persister
        
        reports = persister.persistedReports()
    }
    
    func getWeather(_ coordinate: Coordinate, name: String, completion: @escaping (NamedWeatherReport? ) -> ()) {
        fetcher.getWeather(coordinate, name: name) { [weak self] report, error  in
            guard let strongSelf = self else {
                return
            }
            
            if let report {
                var toSave = [report]
                toSave.append(contentsOf: strongSelf.reports)
                strongSelf.persister.persist(reports: toSave)
            }
            completion(report)
            strongSelf.reports = strongSelf.persister.persistedReports()
        }
    }
}
