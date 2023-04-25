//
//  LocalWeatherPicsCache.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/24/23.
//

import Foundation


import Foundation
import UIKit

class WeatherPicsController {
     
    let urlRequestsHandler: URLRequestHandling
    
    init(urlRequestsHandler: URLRequestHandling) {
        self.urlRequestsHandler = urlRequestsHandler
    }
    
    private var cachedPics: [String:UIImage] = [:]
    
    // Public api
    
    func cachedPic(_ picId: String) -> UIImage? {
        return cachedPics[picId]
    }
    
    private func fileName(for picId: String) -> String {
        let logoFileName = "\(picId).pic"
        return logoFileName
    }
    private func cachedLogoFileUrl(_ picId: String) -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDir = urls[0]
        return documentsDir.appendingPathComponent(fileName(for: picId))
    }
    
    private func orgsWithNoLogo(orgs: [String]) -> [String] {
        return orgs.filter {!FileManager.default.fileExists(atPath:cachedLogoFileUrl($0).path) }
    }
    
    private func populateCache(picIds: [String]) {
        
        let uncashed = picIds.filter { cachedPic($0) == nil }
        
        for picId in uncashed {
            if let image = UIImage(contentsOfFile: cachedLogoFileUrl(picId).path) {
                cachedPics[picId] = image
            }
        }
    }
    
    public func updateAndStartFetchingMissingLogos(picIds: [String]) {
        populateCache(picIds: picIds)
        
        let notYetDownloaded = orgsWithNoLogo(orgs: picIds)
        
        for picId in notYetDownloaded {
            downloadLogoImage(pickId: picId)
        }
        
    }
    
    private func remoteUrlForWeatherPicId(_ picId: String ) -> URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(picId)@2x.png")
    }
    
    private func downloadLogoImage(pickId: String) -> Void {
        guard let url = remoteUrlForWeatherPicId(pickId) else {
            // TODO: ERR!
            return
        }
        let request = URLRequest(url: url)
        
        urlRequestsHandler.handle(request) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data, let image = UIImage(data: data) {
                self.cachedPics[pickId] = image
                try! data.write(to: self.cachedLogoFileUrl(pickId))
                NotificationCenter.default
                    .post(name:NSNotification.Name(NotificationNames.picCacheUpdated),
                          object: nil,
                          userInfo: nil)
            }
        }
    }
}
