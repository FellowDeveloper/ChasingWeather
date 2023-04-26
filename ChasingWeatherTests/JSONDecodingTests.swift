//
//  JSONDecodingTests.swift
//  ChasingWeatherTests
//
//  Created by Anton Tugolukov on 4/21/23.
//

import XCTest
@testable import ChasingWeather


struct Report : Codable {
    let latitude: Double
    let longitude: Double
    let description: String
    let icon: String
    let temp: Double
    let humidity: Int
    let windSpeed: Double
    let windDirection: Double
    let sunrise: Date
    let sunset: Date
}

struct FlattenedReport : Codable {
    let latitude: Double
    let longitude: Double
    let description: String
    let icon: String
    let temp: Double
    let humidity: Int
    let windSpeed: Double
    let windDirection: Double
    let sunrise: Date
    let sunset: Date
    
    // All that boilerplate to flatten the response.
    // Result object is easier to use but conversion logic is somewhat involved
    // Probably not worse than 1:1 mapping with structs to ugly json...
    
    private enum RootKeys: String, CodingKey {
        case coord
        case weather
        case main
        case wind
        case sys
    }
    
    private enum CoordKeys: String, CodingKey {
        case lat
        case lon
    }
    
    private enum MainKeys: String, CodingKey {
        case temp
        case humidity
    }
    
    private enum WindKeys: String, CodingKey {
        case speed
        case deg
    }
    
    private enum SysKeys: String, CodingKey {
        case sunrise
        case sunset
    }
    
    struct Weather : Codable {
        let id: Int
        let main: String
        let description : String
        let icon: String
    }
    
    init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy:RootKeys.self)
        do {
            let weather = try root.decode([Weather].self, forKey: RootKeys.weather).first!
            self.icon = weather.icon
            self.description = weather.description
        
            let container = try root.nestedContainer(keyedBy: MainKeys.self, forKey: RootKeys.main)
            self.temp = try container.decode(Double.self, forKey:.temp)
            self.humidity = try container.decode(Int.self, forKey:.humidity)
            
            let wnd = try root.nestedContainer(keyedBy:WindKeys.self, forKey: RootKeys.wind)
            self.windSpeed = try wnd.decode(Double.self, forKey: WindKeys.speed)
            self.windDirection = try wnd.decode(Double.self, forKey: WindKeys.deg)
            
            let sys = try root.nestedContainer(keyedBy:SysKeys.self, forKey: RootKeys.sys)
            self.sunset = Date(timeIntervalSince1970: try sys.decode(Double.self, forKey: SysKeys.sunset))
            self.sunrise = Date(timeIntervalSince1970: try sys.decode(Double.self, forKey: SysKeys.sunrise))
            
            let latLon = try root.nestedContainer(keyedBy:CoordKeys.self, forKey: RootKeys.coord)
            self.latitude = try latLon.decode(Double.self, forKey: CoordKeys.lat)
            self.longitude = try latLon.decode(Double.self, forKey: CoordKeys.lon)
        }
        catch {
            //print ("Weather report decoding error: \(error)")
            throw error
        }
    }
}

final class JSONDecodingTests: XCTestCase {
    
    func getFakeResponse() -> String {
        return """
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
    }
    
    
    func testJsonDecoding() throws {
        let response = getFakeResponse()
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedResponse = try? jsonDecoder.decode(WeatherReport.self, from: response.data(using: .utf8)!)
        
        XCTAssertNotNil(decodedResponse)
    }
    
    
    func testFlattenAndDecode() throws {
        let response = getFakeResponse()
        
        let jsonDecoder = JSONDecoder()
        let decodedResponse = try? jsonDecoder.decode(FlattenedReport.self, from: response.data(using: .utf8)!)
        print("flatten response: \(String(describing: decodedResponse))")
        
        XCTAssertNotNil(decodedResponse)

    }
    
    
    func testFlattenEncode() throws {
        let response = getFakeResponse()
        
        let jsonDecoder = JSONDecoder()
        let decodedResponse = try? jsonDecoder.decode(FlattenedReport.self, from: response.data(using: .utf8)!)
        print("flatten response: \(String(describing: decodedResponse))")
        
        let encoder = JSONEncoder()
        let encodedJsonData = try? encoder.encode(decodedResponse)
        XCTAssertNotNil(encodedJsonData)
        
        let encodedJsonString = String(data: encodedJsonData!, encoding: .utf8)
        print("Encoded string: \(String(describing: encodedJsonString))")
        
        XCTAssertNotNil(decodedResponse)

    }
    
    func testFlattenDecode() throws {
        let flattenJson = """
        {
            "sunset" : 703592987,
            "humidity" : 42,
            "longitude" : 121.8853,
            "windDirection" : 110,
            "temp" : 291.88999999999999,
            "windSpeed" : 3.5499999999999998,
            "latitude" : 37.338700000000003,
            "description" : "clear sky",
            "sunrise" : 703545196,
            "icon" : "01d"
        }
        """
        
        let jsonDecoder = JSONDecoder()
        let decodedResponse = try? jsonDecoder.decode(Report.self, from: flattenJson.data(using: .utf8)!)
        print("flatten response: \(String(describing: decodedResponse))")
        XCTAssertNotNil(decodedResponse)
    }
}

