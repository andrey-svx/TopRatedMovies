//
//  RatingCircleView.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 01.11.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class CircleRatingView: UIView {
    
    var rating: Int? = 0 {
        didSet {            
            ratingLabel.text = "\(rating ?? 0)%"
        }
    }
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewAndSubviews()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewAndSubviews() {
        backgroundColor = .systemRed
        addSubview(ratingLabel)
    }
    
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            ratingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2.0
    }
}


extension Reactive where Base: CircleRatingView {
    
    var rating: Binder<Int?> {
        Binder(base) { circleRatingView, value in
            circleRatingView.rating = value
        }
    }
}