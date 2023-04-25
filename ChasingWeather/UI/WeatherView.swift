//
//  WeatherView.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/24/23.
//

import UIKit

class WeatherView: UIView {
    var report: NamedWeatherReport? {
        didSet {
            if let report = report {
                nameLabel.text = report.name
                descriptionLabel.text = report.report.weather[0].main
                degreesLabel.text = "\(report.report.main.temp) F"
                
                let dateExtractor = DateFormatter()
                dateExtractor.dateFormat = "d MMM y, E"
                dateLabel.text = dateExtractor.string(from: report.created)
                
                /*
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let sunrize = Date(timeIntervalSince1970:Double(report.report.sys.sunrise))
                sunriseLabel.text = "Sunrize: \(formatter.string(from: sunrize))"
                
                let sunset = Date(timeIntervalSince1970:Double(report.report.sys.sunset))
                sunsetLabel.text = "Sunset: \(formatter.string(from:sunset))"
                 */
                
                //windSpeed.text = "Wind speed: \(report.report.wind.speed)"
                //windDirection.text = "Wind direction: \(report.report.wind.deg)"
            }
            
        }
    }
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var degreesLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var sunriseLabel: UILabel!
    @IBOutlet var sunsetLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
}
