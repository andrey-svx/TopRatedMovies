//
//  CustomPlugin.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 05.11.2022.
//

import Foundation
import Moya

struct CustomPlugin: PluginType {
    
    private let prepareClosure: (_ request: URLRequest, _ target: TargetType) -> URLRequest
    private let didReceiveClosure: (_ result: Result<Response, MoyaError>, _ target: TargetType) -> Void
    
    init(
        _ prepareClosure: @escaping (URLRequest, TargetType) -> URLRequest,
        _ didReceiveClosure: @escaping (_ result: Result<Response, MoyaError>, _ target: TargetType) -> Void
    ) {
        self.prepareClosure = prepareClosure
        self.didReceiveClosure = didReceiveClosure
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        prepareClosure(request, target)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        didReceiveClosure(result, target)
    }
}
