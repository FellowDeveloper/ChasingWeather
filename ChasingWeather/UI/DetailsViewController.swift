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
    
    @IBOutlet var detailPlaceholder: UIView!
    var weatherView: WeatherView!
    
    override func viewWillAppear(_ animated: Bool) {
        if weatherView == nil {
            let weatherView: WeatherView = .fromNib()
            
            weatherView.translatesAutoresizingMaskIntoConstraints = false
            detailPlaceholder.addSubview(weatherView)
            
            let constraints = [
                weatherView.topAnchor.constraint(equalTo: detailPlaceholder.safeAreaLayoutGuide.topAnchor),
                weatherView.leftAnchor.constraint(equalTo: detailPlaceholder.leftAnchor),
                weatherView.rightAnchor.constraint(equalTo: detailPlaceholder.rightAnchor),
                weatherView.bottomAnchor.constraint(equalTo: detailPlaceholder.bottomAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            self.weatherView = weatherView
        }
        
        if let report {
            show(report)
        }
    }
    
    fileprivate func updateUiStyle() {
        self.view.backgroundColor = UIConstants.appBackgroundColor
    }
    
    private func show(_ report: NamedWeatherReport?) {
        updateUiStyle()
        weatherView?.report = report
    }
}
