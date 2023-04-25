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
            nameLabel.text = "Yep"
            degreesLabel.text = "Hot!"
        }
    }
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var degreesLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var sunriseLabel: UILabel!
    @IBOutlet var sunsetLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
}
