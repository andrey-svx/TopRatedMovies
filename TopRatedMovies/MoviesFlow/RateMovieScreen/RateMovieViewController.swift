//
//  RateMovieViewController.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class RateMovieViewController: UIViewController, Coordinatable {
    
    enum Output {
        
        case success
        case failure(String)
    }
    
    typealias T = Output
    
    var onCoordinated: ((Output) -> Void)?
        
    private let viewModel: RateMovieViewModel
    
    private lazy var transition: SlideTransition = {
        let transition = SlideTransition()
        transition.onDismissed = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        return transition
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24.0, weight: .semibold)
        return label
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 100.0
        slider.tintColor = .systemRed
        return slider
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit review", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 16.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            ratingLabel,
            slider,
            submitButton
        ])
        stack.axis = .vertical
        stack.spacing = 12.0
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: RateMovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = transition
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
        view.addSubview(mainStack)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            submitButton.heightAnchor.constraint(equalToConstant: 48.0),
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12.0)
        ])
    }
    
    private func bindViewModel() {
        let input = RateMovieViewModel.Input(
            ratingSelected: slider.rx.value.asSignal(onErrorJustReturn: 0.0),
            submitTapped: submitButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(
            input
        )
        
        output.rating
            .drive(ratingLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(self.rx.isLoading)
            .disposed(by: disposeBag)
        
        output.coordinate
            .drive(onNext: { [weak self] in self?.onCoordinated?($0) })
            .disposed(by: disposeBag)
    }
}
