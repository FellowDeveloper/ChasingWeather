//
//  WeatherDataRetriever.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/21/23.
//

import Foundation

struct OpenWeatherAPIGateway {
    let requestsHandler: URLRequestHandling
    let apiKey: String
    
    private func requestUrl(for coordinate: Coordinate) -> URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.lat)&lon=\(coordinate.lon)&appid=\(apiKey)")!
    }
    
    enum DataRetrivingErrors : Error {
        case noDataError, decodingError
    }
    
    func getWeather(_ coord: Coordinate, name: String, completion:@escaping (NamedWeatherReport?, Error?) -> ()) {
        
        let url = requestUrl(for: coord)
        let created = Date()
        
        requestsHandler.handle(URLRequest(url: url)) { data, response, error in
            
            guard let data = data else {
                let err = error ?? DataRetrivingErrors.noDataError
                print("Err fetching weather data: \(err)")
                completion(nil, err)
                return
            }
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("String response:\(dataString)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            var result : NamedWeatherReport?
            
            //Swallowing decoding errors for now
            do {
                let report = try decoder.decode(WeatherReport.self, from: data)
                result = NamedWeatherReport(report: report, created: created, name: name)
            }
            catch {
                print("Err: \(error)")
            }
            completion (result, result == nil ? DataRetrivingErrors.decodingError : nil)
        }
    }
}
