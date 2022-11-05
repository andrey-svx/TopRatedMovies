//
//  ViewController.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 30.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class TopRatedMoviesViewController: UIViewController, Coordinatable {
    
    enum Output {
        
        case empty
        case details(MovieDetailsModel)
    }
    
    typealias T = Output
    
    var onCoordinated: ((T) -> Void)?
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout.tiles()
        )
        collectionView.refreshControl = self.refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let viewModel: TopRatedMoviesViewModel
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: TopRatedMoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        configureViewAndSubviews()
        configureLayout()
        bindViewModel()
    }
    
    private func setupCollectionView() {
        collectionView.register(TopRatedMoviesCell.self)
    }
    
    private func configureViewAndSubviews() {
        view.backgroundColor = .white
        navigationItem.title = "Top Rated Movies"
        view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        let input = TopRatedMoviesViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asSignal(),
            didPullCollectionView: refreshControl.rx.pull.asSignal(),
            didSelectItem: collectionView.rx.itemSelected.asSignal()
        )
        
        let output = viewModel.transform(
            input
        )
        
        output.isLoading
            .drive(self.rx.isLoading)
            .disposed(by: disposeBag)
        
        output.items
            .drive(collectionView.rx.items) { (collectionView, row, model) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell: TopRatedMoviesCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.model = model
                return cell
            }
            .disposed(by: disposeBag)
        
        output.isRefreshing
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.coordinate
            .drive(onNext: { [weak self] in self?.onCoordinated?($0) })
            .disposed(by: disposeBag)
    }
}

fileprivate extension UICollectionViewCompositionalLayout {
    
    static func tiles() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.45),
            heightDimension: .estimated(CGFloat.leastNonzeroMagnitude)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(CGFloat.leastNonzeroMagnitude)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .flexible(CGFloat.leastNonzeroMagnitude)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 24.0
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8.0,
            leading: 8.0,
            bottom: 8.0,
            trailing: 8.0
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
