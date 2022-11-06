//
//  APIConstantsProvider.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 02.11.2022.
//

import Foundation

final class NetworkingConfigProvider {
    
    let mainHost: String
    let imagesHost: String
    let apiKey: String
    let initialAccessToken: String
    
    static let shared = NetworkingConfigProvider()
    
    private init() {
        
        guard let url = Bundle.main.url(forResource: "NetworkingConfig", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
              let config = plist as? Dictionary<String, String> else {
                  fatalError("Could not find config dicitionary")
              }
        
        guard let mainHost = config["main_host"],
              let imagesHost = config["images_host"],
              let apiKey = config["api_key"],
              let initialAccessToken = config["initial_access_token"] else {
                  fatalError("Could not find all values")
              }

        self.mainHost = mainHost
        self.imagesHost = imagesHost
        self.apiKey = apiKey
        self.initialAccessToken = initialAccessToken
    }
}
