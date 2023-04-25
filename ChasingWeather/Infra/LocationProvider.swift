//
//  LocationObtainer.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/23/23.
//

import Foundation
import CoreLocation

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

struct Location {
    let city: String
    let coordinate: Coordinate
}

protocol LocationProvider {
    var currentLocation : Location? { get }
}

class LocationController : NSObject, LocationProvider, CLLocationManagerDelegate {

    var locationEnabled: Bool  {
        return CLLocationManager.locationServicesEnabled()
    }
    
    @Published var currentLocation: Location?
    private var locationManager: CLLocationManager
    
    
    fileprivate func getCityAndPublish(for location: CLLocation) {
        location.fetchCityAndCountry { city, country, error in
            // Fixme: add err handling
            if let city = city {
                self.currentLocation = Location(city: city, coordinate: Coordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude))
            }
        }
    }
    
    fileprivate func startUpdatingIfEnabled() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            if let loc = locationManager.location {
                getCityAndPublish(for: loc)
            }
        }
    }
    
    override init() {
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        super.init()
        
        startUpdatingIfEnabled()
    }
    
    
    func startUpdating() {
        startUpdatingIfEnabled()
        
        if (!self.locationEnabled) {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("INFO: Retrieved locations: \(locations)")
        
        if let loc = locations.first {
            self.getCityAndPublish(for: loc)
        }
    }
}


