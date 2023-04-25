//
//  ViewController.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/18/23.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var weatherViewPlaceholder: UIView!
    @IBOutlet var previousSearshesTable: UITableView!
    var weatherView: WeatherView?
    
    private func updateUi()
    {
        if let weatherView = weatherView, let report = reports.first{
            weatherView.nameLabel.text = report.name
            self.previousSearshesTable?.reloadData()
        }
    }
    
    var reports: [NamedWeatherReport] = [] {
        didSet {
            
            if let picController = serviceLocator?.picsController {
                let picIds = Set(reports.map( { $0.report.weather[0].icon }))
                picController.updateAndStartFetchingMissingLogos(picIds: Array(picIds))
            }
        }
    }
    var serviceLocator: AppDelegate.ServiceLocator!
    
    @objc func weatherImageLoaded(_ notification: Notification) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let weatherView: WeatherView = .fromNib()
        
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        weatherViewPlaceholder.addSubview(weatherView)
        
        let constraints = [
            weatherView.topAnchor.constraint(equalTo: weatherViewPlaceholder.safeAreaLayoutGuide.topAnchor),
            weatherView.leftAnchor.constraint(equalTo: weatherViewPlaceholder.leftAnchor),
            weatherView.rightAnchor.constraint(equalTo: weatherViewPlaceholder.rightAnchor),
            weatherView.bottomAnchor.constraint(equalTo: weatherViewPlaceholder.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    
        
        self.view.backgroundColor = UIConstants.appBackgroundColor
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.serviceLocator = appDelegate.serviceLocator
        self.previousSearshesTable.rowHeight = UITableView.automaticDimension
        self.previousSearshesTable.estimatedRowHeight = 50
        previousSearshesTable.register(UINib(nibName: "PrevSearchesCell", bundle: nil), forCellReuseIdentifier: "previous-searches-cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reports = serviceLocator.weatherDataController.reports
        updateUi()
        
        super.viewWillAppear(animated)
        NotificationCenter.default
                          .addObserver(self,
                                       selector: #selector(weatherImageLoaded),
                                       name: NSNotification.Name (NotificationNames.picCacheUpdated),
                                       object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func showDetails(of report:NamedWeatherReport) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: UIConstants.showDetailsSequeId, sender: report)
        }
    }
    
    // MARK - TableViewDelegate / DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetails(of: reports[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "previous-searches-cell") as? PrevSearchesCell {
            cell.backgroundColor = UIConstants.appBackgroundColor
            cell.nameLabel?.textColor = UIConstants.appTextColor
            cell.dateLabel?.textColor = UIConstants.appTextColor
            cell.descriptionLabel?.textColor = UIConstants.appTextColor
            
            
            let report = reports[indexPath.row]
            
            cell.nameLabel.text = report.name
            cell.descriptionLabel.text = reports[indexPath.row].report.weather.first?.main
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM @ HH:mm"
            cell.dateLabel.text = formatter.string(from: report.created)
            
            if let pic = serviceLocator.picsController.cachedPic(report.report.weather[0].icon)
            {
                cell.pic.image = pic
                cell.pic.contentMode = .scaleAspectFit
            }
            
            return cell
        }
        fatalError("ERROR! Cell not registered for PreviousSearchesViewController")
    }
    
    @IBAction func showCurrent(_ sender: UIControl) {
        if let location = serviceLocator.locationProvider.currentLocation {
            //Yay, we do have a location. Get weather report and show view
            print ("Getting weather for location: \(location)")
            
            serviceLocator.weatherDataController.getWeather(location.coordinate, name: location.city) { report in
                if let report = report {
                    self.showDetails(of: report)
                }
                else {
                    print("ERR: Failed to get weather report for current location")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == UIConstants.showDetailsSequeId {
            guard let weatherReport = sender as? NamedWeatherReport else { return }
            
            if let destinationVC = segue.destination as? DetailsViewController {
                destinationVC.report = weatherReport
            }
            
        }
    }
}

