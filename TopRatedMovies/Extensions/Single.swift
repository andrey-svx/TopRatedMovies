//
//  ObservableType.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 04.11.2022.
//

import Foundation
import RxSwift

extension Single {
    
    func wrapToResult() -> Single<Result<Element, Error>> {
        asObservable()
            .map { .success($0) }
            .catch { .just(.failure($0)) }
            .asSingle()
    }
    
    func unwrapSuccess<S, F: Error>() -> Single<S> where Element == Result<S, F> {
        asObservable()
            .filter { result in
                switch result {
                case .success:
                    return true
                case .failure:
                    return false
                }
            }
            .map { result in
                switch result {
                case .success(let output):
                    return output
                case .failure:
                    fatalError("Unhandled state")
                }
            }
            .asSingle()
    }
    
    func unwrapFailure<S, F: Error>() -> Single<F> where Element == Result<S, F> {
        asObservable()
            .filter { result in
                switch result {
                case .success:
                    return false
                case .failure:
                    return true
                }
            }
            .map { result in
                switch result {
                case .success:
                    fatalError("Unhandled state")
                case .failure(let error):
                    return error
                }
            }
            .asSingle()
    }
}
