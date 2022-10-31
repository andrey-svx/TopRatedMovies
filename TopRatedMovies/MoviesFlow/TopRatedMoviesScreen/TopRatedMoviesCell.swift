//
//  TopRatedMoviesCell.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 31.10.2022.
//

import UIKit

final class TopRatedMoviesCell: UICollectionViewCell {
    
    struct Model {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemYellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopRatedMoviesCell: ReuseIdentifiable { }
