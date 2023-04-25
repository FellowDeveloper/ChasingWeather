//
//  JSONDecodingTests.swift
//  ChasingWeatherTests
//
//  Created by Anton Tugolukov on 4/21/23.
//

import XCTest
@testable import ChasingWeather

final class JSONDecodingTests: XCTestCase {
    func testJsonDecoding() throws {
   let response = """
        {
            "coord": {
                "lon": 121.8853,
                "lat": 37.3387
            },
            "weather": [
                {
                    "id": 800,
                    "main": "Clear",
                    "description": "clear sky",
                    "icon": "01d"
                }
            ],
            "base": "stations",
            "main": {
                "temp": 291.89,
                "feels_like": 290.92,
                "temp_min": 291.89,
                "temp_max": 291.89,
                "pressure": 1010,
                "humidity": 42,
                "sea_level": 1010,
                "grnd_level": 997
            },
            "visibility": 10000,
            "wind": {
                "speed": 3.55,
                "deg": 110,
                "gust": 3.98
            },
            "clouds": {
                "all": 0
            },
            "dt": 1681873788,
            "sys": {
                "country": "CN",
                "sunrise": 1681852396,
                "sunset": 1681900187
            },
            "timezone": 28800,
            "id": 1791536,
            "name": "Tianfu",
            "cod": 200
        }
        """
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedResponse = try? jsonDecoder.decode(WeatherReport.self, from: response.data(using: .utf8)!)
        
        XCTAssertNotNil(decodedResponse)
    }
    
}

