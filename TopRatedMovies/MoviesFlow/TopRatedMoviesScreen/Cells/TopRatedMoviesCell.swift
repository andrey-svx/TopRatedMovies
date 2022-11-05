//
//  TopRatedMoviesCell.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 31.10.2022.
//

import UIKit

final class TopRatedMoviesCell: UICollectionViewCell {
    
    struct Model {
        
        let image: UIImage?
        let title: String
        let year: String
        let rating: Int
    }
    
    var model: Model? {
        didSet {
            guard let model = model else {
                return
            }

            posterView.image = model.image
            titleLabel.text = model.title
            yearLabel.text = model.year
            ratingView.rating = model.rating
        }
    }
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12.0
        imageView.backgroundColor = .systemBlue
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = .gray
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            yearLabel
        ])
        stack.axis = .vertical
        stack.spacing = 4.0
        stack.setContentCompressionResistancePriority(.required, for: .vertical)
        stack.setContentHuggingPriority(.required, for: .vertical)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            posterView,
            labelsStack
        ])
        stack.axis = .vertical
        stack.spacing = 28.0
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let ratingView: CircleRatingView = {
        let ratingView = CircleRatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
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
        contentView.addSubview(mainStack)
        contentView.addSubview(ratingView)
    }
    
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            ratingView.widthAnchor.constraint(equalToConstant: 48.0),
            ratingView.heightAnchor.constraint(equalTo: ratingView.widthAnchor),
            ratingView.centerXAnchor.constraint(equalTo: posterView.leadingAnchor, constant: 24.0 + 16.0),
            ratingView.centerYAnchor.constraint(equalTo: posterView.bottomAnchor)
        ])
    }
}

extension TopRatedMoviesCell: ReuseIdentifiable { }
