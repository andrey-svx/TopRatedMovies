//
//  ViewController.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 30.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class TopRatedMoviesViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout.tiles()
        )
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
        configureSubviews()
        configureAutoLayout()
        bindViewModel()
    }
    
    private func setupCollectionView() {
        collectionView.register(TopRatedMoviesCell.self)
    }
    
    private func configureSubviews() {
        view.backgroundColor = .white
        navigationItem.title = "Top Rated Movies"
        
        view.addSubview(collectionView)
    }
    
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        let input = TopRatedMoviesViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asSignal()
        )
        let output = viewModel.transform(
            input
        )
        output.items
            .drive(collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell: TopRatedMoviesCell = collectionView.dequeueReusableCell(for: indexPath)
                return cell
            }
            .disposed(by: disposeBag)
    }
}

fileprivate extension UICollectionViewCompositionalLayout {
    
    static func tiles() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.45),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .flexible(4.0),
            top: nil,
            trailing: .flexible(4.0),
            bottom: nil
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 24.0
        return UICollectionViewCompositionalLayout(section: section)
    }
}
