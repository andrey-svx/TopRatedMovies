//
//  MovieDetailsViewController.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 05.11.2022.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    
    private let viewModel: MovieDetailsViewModel
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
    }
}
