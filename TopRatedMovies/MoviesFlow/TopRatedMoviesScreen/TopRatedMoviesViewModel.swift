//
//  TopRatedMoviesViewModel.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 31.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class TopRatedMoviesViewModel {
    
    struct Input {
        
        let viewWillAppear: Signal<Void>
    }
    
    struct Output {
        
        let items: Driver<[TopRatedMoviesCell.Model]>
    }
    
    func transform(_ input: Input) -> Output {
        let items = input.viewWillAppear
            .map { _ -> [TopRatedMoviesCell.Model] in
                [.init(), .init(), .init(), .init(), .init()]
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(items: items)
    }
}
