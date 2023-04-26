//
//  AppDelegate.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/18/23.
//

import UIKit




@main
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    class LocationProviderFake : LocationProvider {
        var currentLocation: Location? {
            //Location(city: "New York", coordinate: Coordinate(lat: 40.7, lon: 74.0060))
            Location(city: "Cupertino, CA", coordinate: Coordinate(lat: 37.31, lon: -122.04))
        }
    }
    
    struct ServiceLocator {
        let weatherDataController : WeatherDataController
        let urlRequestsHandler : URLRequestHandling
        var locationProvider : LocationProvider
        var picsController : WeatherPicsController
        
    }
    
    var serviceLocator: ServiceLocator?
    
    private func customiseStatusBarAppearance(){
        
        UINavigationBar.appearance().backgroundColor = UIConstants.appBackgroundColor
        UINavigationBar.appearance().barTintColor = UIConstants.navBarTintColor
        UIBarButtonItem.appearance().tintColor = UIConstants.appTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIConstants.navBarTextColor]
    }

    fileprivate func configureAppDependencies() {
        // Centralized place of dependencies creation. Objects needing dependency do not create them but ask the service locator
        // Object implementations can be swapped based on environment
        // (ex switch between memory and file store for debug / prod, stubs with network request data for unit tests, etc...
        
        let requestsHandler = URLRequestHandler()
        let weatherApiGateway = OpenWeatherAPIGateway(requestsHandler: requestsHandler,
                                                      apiKey: "0ea3dba95c348c47cfdae63c8c95f802")
        
        //Reuse same request handler instance in pics controller to not write network logic twice:
        let picsController = WeatherPicsController(urlRequestsHandler: requestsHandler)
        let reportsStorage = UserDefaultsWeatherStorage()
        let dataController = WeatherDataController(fetcher:weatherApiGateway, storage:reportsStorage)
        
#if targetEnvironment(simulator)
        let locationProvider = LocationProviderFake()
#else
        //let locationProvider = LocationController()
        let locationProvider = LocationProviderFake()
#endif
        
        self.serviceLocator = ServiceLocator(weatherDataController: dataController, urlRequestsHandler: requestsHandler, locationProvider: locationProvider, picsController: picsController)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        configureAppDependencies()
        customiseStatusBarAppearance()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

