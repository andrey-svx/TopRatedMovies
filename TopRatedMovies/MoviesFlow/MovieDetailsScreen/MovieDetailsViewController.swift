//
//  MovieDetailsViewController.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 05.11.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieDetailsViewController: UIViewController {
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12.0
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 20.0, weight: .medium)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let ratingView: CircleRatingView = {
        let ratingView = CircleRatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()
        
    private lazy var rightStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            yearLabel
        ])
        stack.axis = .vertical
        stack.spacing = 8.0
        return stack
    }()

    private lazy var topStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            posterView,
            rightStack
        ])
        stack.axis = .horizontal
        stack.spacing = 12.0
        stack.alignment = .top
        return stack
    }()
    
    private let bottomSpacer: UIView = {
        let view = UIView()
        view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            topStack,
            overviewLabel,
            bottomSpacer
        ])
        stack.axis = .vertical
        stack.spacing = 24.0 + 12.0
        stack.distribution = .fill
        stack.clipsToBounds = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let viewModel: MovieDetailsViewModel
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewAndSubviews()
        configureLayout()
        bindViewModel()
    }
    
    private func configureViewAndSubviews() {
        view.backgroundColor = .white
        navigationItem.title = "Movie Details"
        view.addSubview(mainStack)
        view.addSubview(ratingView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            posterView.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1/2),
            posterView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/2),
            
            bottomSpacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 100.0),
            
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12.0),
            
            ratingView.widthAnchor.constraint(equalToConstant: 48.0),
            ratingView.heightAnchor.constraint(equalTo: ratingView.widthAnchor),
            ratingView.centerXAnchor.constraint(equalTo: posterView.leadingAnchor, constant: 24.0 + 16.0),
            ratingView.centerYAnchor.constraint(equalTo: posterView.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        let input = MovieDetailsViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asSignal()
        )
        
        let output = viewModel.transform(
            input
        )
        
        output.poster
            .drive(posterView.rx.image)
            .disposed(by: disposeBag)
        
        output.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.year
            .drive(yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.overview
            .drive(overviewLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
