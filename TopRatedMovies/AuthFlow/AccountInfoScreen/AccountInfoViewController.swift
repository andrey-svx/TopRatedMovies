//
//  AccountInfoViewController.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class AccountInfoViewController: UIViewController, Coordinatable {

    enum Output {
        
        case approve(String)
        case failure(String)
    }

    typealias T = Output

    var onCoordinated: ((Output) -> Void)?    
    
    private let viewModel: AccountInfoViewModel
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let authButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemRed, for: .normal)
        button.tintColor = .systemRed
        button.setTitle("Заголовок", for: .normal)
        button.setImage(UIImage(systemName: "person"), for: .normal)
        return button
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            statusLabel,
            authButton
        ])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: AccountInfoViewModel) {
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
        navigationItem.title = "Authorization"
        view.addSubview(mainStack)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60.0),
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40.0),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40.0)
        ])
    }
    
    private func bindViewModel() {
        
        let input = AccountInfoViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asSignal(),
            buttonTapped: authButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(
            input
        )
        
        output.statusMessage
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.authButtonTitle
            .drive(authButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        output.authButtonImage
            .drive(authButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(self.rx.isLoading)
            .disposed(by: disposeBag)
        
        output.coordinate
            .drive(onNext: { [weak self] in self?.onCoordinated?($0) })
            .disposed(by: disposeBag)
        
        output.ground
            .drive()
            .disposed(by: disposeBag)
    }
}
