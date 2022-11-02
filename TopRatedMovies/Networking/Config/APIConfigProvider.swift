//
//  APIConstantsProvider.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 02.11.2022.
//

import Foundation

final class APIConfigProvider {
    
    let mainHost: String
    let imagesHost: String
    let apiKey: String
    let initialAccessToken: String
    
    static let shared = APIConfigProvider()
    
    private init() {
        let url = Bundle.main.url(forResource: "APIConfig", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let plist = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        let config = plist as! Dictionary<String, String>
        
        self.mainHost = config["main_host"]!
        self.imagesHost = config["images_host"]!
        self.apiKey = config["api_key"]!
        self.initialAccessToken = config["initial_access_token"]!
    }
}
