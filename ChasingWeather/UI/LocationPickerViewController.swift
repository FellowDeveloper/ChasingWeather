//
//  LocationPickerViewController.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/21/23.
//

import UIKit
import MapKit

/*
 * TODOs and Nice To Haves
 *
 * Extract annotation view so a separate file
 *
 * UX: Optimize. Design. Not quite clear what is happening...
 *   Long press gets coordinate and starts async name fetch
 *   On name fetch annotation is added
 *   Annotation can be tapped to show callout with button
 *   Callout button gets user to weather report details screen from this location...
 *
 * Magic numbers, strings and access control tweaks
 */


class CustomAnnotationView: MKMarkerAnnotationView {
    
    var callout : (() -> ())?
    
    @objc private func calloutCallback(_ sender: Any?) {
        callout?()
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        canShowCallout = true
        let btn = UIButton(type: .infoLight)
        btn.addTarget(self, action: #selector(calloutCallback), for: .touchUpInside)
        rightCalloutAccessoryView = btn
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class LocationPickerViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private static let annotationReuseId = "com.this.app.map.annotation.with.callout"
    
    private var serviceLocator: AppDelegate.ServiceLocator!
    
    var annotation : MKPointAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: LocationPickerViewController.annotationReuseId)
        serviceLocator = (UIApplication.shared.delegate as! AppDelegate).serviceLocator!
        
        if let location = serviceLocator.locationProvider.currentLocation {
            let coord2d = CLLocationCoordinate2D(latitude: location.coordinate.lat, longitude: location.coordinate.lon)
            let region = MKCoordinateRegion(center: coord2d, latitudinalMeters: 13000, longitudinalMeters: 13000)
            mapView.setRegion(region, animated: false)
        }
        
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addPinAndStartFetchingCity(sender:)))
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    fileprivate func removeMapAnnotations() {
        if let oldAnnotation = self.annotation {
            self.mapView.removeAnnotations([oldAnnotation])
        }
    }
    
    fileprivate func addAnnotation(_ name: String, _ coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        self.annotation = annotation
    }
    
    @IBAction func addPinAndStartFetchingCity(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        
        self.removeMapAnnotations()
        location.fetchCityAndCountry {
            [weak self]
            city, country, error in
            if let city = city {
                self?.addAnnotation(city, location.coordinate)
            }
        }
    }
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: LocationPickerViewController.annotationReuseId) as? CustomAnnotationView
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: LocationPickerViewController.annotationReuseId)
        }
        
        annotationView?.annotation = annotation
        annotationView?.callout = {
            let coord = Coordinate(lat: annotation.coordinate.latitude, lon: annotation.coordinate.longitude)
            if let optName = annotation.title, let name = optName {
                self.serviceLocator.weatherDataController.getWeather(coord, name: name ) {
                    [weak self]
                    report in
                    if let report = report {
                        self?.showDetails(of: report)
                    }
                }
            }
        }

        return annotationView
    }
    
    private func showDetails(of report:NamedWeatherReport) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: UIConstants.showReportFromMapSegueId,
                              sender: report)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == UIConstants.showReportFromMapSegueId {
            guard let weatherReport = sender as? NamedWeatherReport else { return }
            
            if let destinationVC = segue.destination as? DetailsViewController {
                destinationVC.report = weatherReport
            }
            
        }
    }
}
