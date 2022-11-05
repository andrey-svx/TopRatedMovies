//
//  CustomPlugin.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 05.11.2022.
//

import Foundation
import Moya

struct CustomPlugin<Target: TargetType>: PluginType {
    
    private let prepareClosure: (_ request: URLRequest, _ target: Target) -> URLRequest
    private let didReceiveClosure: (_ result: Result<Response, MoyaError>, _ target: Target) -> Void
    
    init(
        _ prepareClosure: @escaping (URLRequest, Target) -> URLRequest,
        _ didReceiveClosure: @escaping (_ result: Result<Response, MoyaError>, _ target: Target) -> Void
    ) {
        self.prepareClosure = prepareClosure
        self.didReceiveClosure = didReceiveClosure
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? Target else {
            return request
        }
        
        return prepareClosure(request, target)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard let target = target as? Target else {
            return
        }
        
        didReceiveClosure(result, target)
    }
}
