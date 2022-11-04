//
//  SessionIdentified.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 05.11.2022.
//

import Foundation
import Moya

enum SessionIdentifier {
    case sessionId, guestSessionId
}

protocol SessionIdentifiable: TargetType {

    var sessionIdentifier: SessionIdentifier? { get }
}

struct SessionIdentifiablePlugin: PluginType {
    
    private let sessionIdentifierClosure: (SessionIdentifier) -> String
    
    init(_ sessionIdentifierClosure: @escaping (SessionIdentifier) -> String) {
        self.sessionIdentifierClosure = sessionIdentifierClosure
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        guard let sessionIdentifiableTarget = target as? SessionIdentifiable,
              let sessionIdentifier = sessionIdentifiableTarget.sessionIdentifier else {
                  return request
              }
        
        var components = request.url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: true) }
        let name: String
        switch sessionIdentifier {
        case .sessionId:
            name = "session_id"
        case .guestSessionId:
            name = "guest_session_id"
        }
        let item = URLQueryItem(name: name, value: sessionIdentifierClosure(sessionIdentifier))
        components?.queryItems?.append(item)
        
        var request = request
        request.url = components?.url
        
        return request
    }
}
