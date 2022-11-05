//
//  RatingCircleView.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 01.11.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class CircleRatingControl: UIControl {
    
    var rating: Int? = 0 {
        didSet {            
            ratingLabel.text = "\(rating ?? 0)%"
        }
    }
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        label.addGestureRecognizer(recognizer)
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
    
    @objc private func handleTap() {
        sendActions(for: .touchUpInside)
    }
}


extension Reactive where Base: CircleRatingControl {
    
    var rating: Binder<Int?> {
        Binder(base) { circleRatingView, value in
            circleRatingView.rating = value
        }
    }
    
    var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
}
