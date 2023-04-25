//
//  DetailsViewController.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/24/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    static func loadFromStoryboard() -> DetailsViewController? {
        let storyboard = UIStoryboard(name:"Main",
                                      bundle:Bundle(for:self))
        let controller = storyboard.instantiateViewController(withIdentifier: "detailed-report-vc-id")
                as? DetailsViewController

        return controller
    }
    
    var report : NamedWeatherReport?

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var mainDesriptionLabel: UILabel!
    @IBOutlet var degreesLabel: UILabel!
    @IBOutlet var windSpeed: UILabel!
    @IBOutlet var windDirection: UILabel!
    @IBOutlet var sunrizeLabel: UILabel!
    @IBOutlet var sunsetLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        if let report {
            show(report)
        }
    }
    
    fileprivate func updateUiStyle() {
        self.view.backgroundColor = UIConstants.appBackgroundColor
        
        for textLabel in [nameLabel, mainDesriptionLabel, degreesLabel, windSpeed, windDirection, sunrizeLabel, sunsetLabel] {
            textLabel?.textColor = UIConstants.appTextColor
        }
    }
    
    private func show(_ report: NamedWeatherReport?) {
        
        updateUiStyle()
        
        if let report {
            nameLabel.text = report.name
            mainDesriptionLabel.text = report.report.weather[0].main
            degreesLabel.text = "Temp: \(report.report.main.temp)"
            let dateExtractor = DateFormatter()
            dateExtractor.dateFormat = "d MMM y, E"
            dateLabel.text = dateExtractor.string(from: report.created)
            
            //TODO: Date formatting to have time only
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let sunrize = Date(timeIntervalSince1970:Double(report.report.sys.sunrise))
            sunrizeLabel.text = "Sunrize: \(formatter.string(from: sunrize))"
            
            let sunset = Date(timeIntervalSince1970:Double(report.report.sys.sunset))
            sunsetLabel.text = "Sunset: \(formatter.string(from:sunset))"
            
            windSpeed.text = "Wind speed: \(report.report.wind.speed)"
            windDirection.text = "Wind direction: \(report.report.wind.deg)"
        }
    }
}
