//
//  TopRatedMoviesViewModel.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 31.10.2022.
//

import RxSwift
import RxCocoa
import UIKit.UIImage

final class TopRatedMoviesViewModel {
    
    struct Input {
        
        let viewWillAppear: Signal<Void>
        let didPullCollectionView: Signal<Void>
    }
    
    struct Output {
        
        let isLoading: Driver<Bool>
        let isRefreshing: Driver<Bool>
        let items: Driver<[TopRatedMoviesCell.Model]>
    }
    
    func transform(_ input: Input) -> Output {
        let viewWillAppearObservable = input.viewWillAppear
            .asObservable()
            .share()
        
        let itemsObservable = viewWillAppearObservable
//            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ -> [TopRatedMoviesCell.Model] in
                (0...10).map { _ in
                    .init(
                        image: UIImage(named: "dark-knight"),
                        name: "Темный Рыцарь",
                        year:  "2015 г",
                        rating: 87
                    )
                    
                }
            }
            .asObservable()
            .share()
        
        let isLoading = Observable
            .merge(
                viewWillAppearObservable.map { _ in true },
                itemsObservable.map { _ in false }
            )
            .asDriver(onErrorJustReturn: false)
        
        let isRefreshing = input.didPullCollectionView
//            .delay(.seconds(1))
            .map { _ in false }
            .asDriver(onErrorJustReturn: false)
        
        let items = itemsObservable
            .asDriver(onErrorJustReturn: [])
        
        return Output(
            isLoading: isLoading,
            isRefreshing: isRefreshing,
            items: items
        )
    }
}
