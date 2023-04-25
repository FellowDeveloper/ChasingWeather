//
//  DetailsViewControllerTests.swift
//  ChasingWeatherTests
//
//  Created by Anton Tugolukov on 4/24/23.
//
import XCTest

@testable import ChasingWeather

class DetailsViewControllerTests: XCTestCase {
    var sut : DetailsViewController?
    
    override func setUp() {
        super.setUp()
        
        sut = DetailsViewController.loadFromStoryboard()
    }
    
    func testCanCreateSystemUnderTest() {
        //Lol system under test kind of loud for this test
        //still this is the pattern that can be used to verify object is created and all preconditions are met and fail early
        XCTAssertNotNil(sut, "cannot create view controller")
    }
    
    func testUIHasExpectedValues() {
        sut?.loadViewIfNeeded()
        let mainDesrciption = "main-desrription!"
        let temperature = 42.0
        let windSpeed = 333.3
        let widDirection = 12
        
        let weatherInfo = [WeatherInfo(id: 12, main: mainDesrciption, description: "", icon: "")]
        let mainWeatherInfo = MainWeatherInfo(temp: temperature, feelsLike: 0, pressure: 0, humidity: 0)
        
        
        
        let weatherReport = WeatherReport(coord: Coordinate(lat: 42.2, lon: 42.2),
                                          weather:weatherInfo ,
                                          main: mainWeatherInfo,
                                          wind: WindInfo(speed: windSpeed, deg: 12, gust: nil),
                                          sys: SunsetSunrizeInfo(country: "", sunrise: 8, sunset: 8))
        let report = NamedWeatherReport(report: weatherReport, created: Date(), name: "TestLand")
        
        sut?.report = report
        sut?.viewWillAppear(false)
        
        guard let mainDescrTextFromUI = sut?.mainDesriptionLabel.text else {
            XCTFail("Unexpexted nil text")
            return
        }
        
        XCTAssertEqual(mainDescrTextFromUI, mainDesrciption)
        
    }

}
