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
        let refreshPulled: Signal<Void>
    }
    
    struct Output {
        
        let isLoading: Driver<Bool>
        let items: Driver<[TopRatedMoviesCell.Model]>
        let refreshReleased: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let viewWillAppear = input.viewWillAppear
            .asObservable()
            .share()
        
        let items = viewWillAppear
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .map { _ -> [TopRatedMoviesCell.Model] in
                (0...24).map { _ in .init() }
            }
            .asObservable()
            .share()
        
        let isLoading = Observable.merge(
            viewWillAppear.map { _ in true },
            items.map { _ in false }
        )
        .asDriver(onErrorJustReturn: false)
        
        let itemsDriver = items
            .asDriver(onErrorJustReturn: [])
        
        let refreshReleased = input.refreshPulled
            .delay(.seconds(1))
            .map { _ in false }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            isLoading: isLoading,
            items: itemsDriver,
            refreshReleased: refreshReleased
        )
    }
}
