//
//  RatingCircleView.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 01.11.2022.
//

import UIKit

final class CircleRatingView: UIView {
    
    var rating: Int = 0 {
        didSet {            
            ratingLabel.text = "\(rating)%"
        }
    }
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
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
