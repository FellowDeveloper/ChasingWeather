//
//  DataFetcher.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/21/23.
//

import Foundation

protocol URLRequestHandling {
    func handle(_ request:URLRequest, completion : @escaping(Data?, URLResponse?, Error?)->Void)
}

class URLRequestHandler : URLRequestHandling {
    func handle(_ request:URLRequest, completion : @escaping(Data?, URLResponse?, Error?)->Void)
    {
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
    
}

struct FakeURLRequestsHandler : URLRequestHandling
{
    struct NoFakeData : Error {}
    
    var fakeResponse : (Data?, URLResponse?, Error?)?
    
    func handle(_ request:URLRequest, completion : @escaping(Data?, URLResponse?, Error?)->Void) {
        let result = fakeResponse ?? (nil, nil, NoFakeData())
        completion(result.0, result.1, result.2)
    }
}
