//
//  AccountInfoViewController.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class AccountInfoViewController: UIViewController {
    
    private let viewModel: AccountInfoViewModel
    
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
    }
    
    private func configureLayout() { }
    
    private func bindViewModel() { }
}
