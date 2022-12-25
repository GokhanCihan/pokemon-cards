//
//  FilteredCardCell.swift
//  pokemon-cards
//
//  Created by Gökhan on 26.11.2022.
//

import UIKit

class FilteredCardCell: UICollectionViewCell {
    static var reuseIdentifier = "filtered-card-cell"
    
    let cardImage = UIImageView()
    let cardLabel = UILabel()
    var isFavorite = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension FilteredCardCell {
    func configureCell() {
        cardImage.translatesAutoresizingMaskIntoConstraints = false
        cardImage.layer.borderColor = UIColor.black.cgColor
        cardImage.layer.borderWidth = 1
        
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        cardLabel.layer.borderColor = UIColor.gray.cgColor
        cardLabel.layer.borderWidth = 1
        cardLabel.adjustsFontForContentSizeCategory = true
        cardLabel.textAlignment = .center
        
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 3
        
        contentView.addSubview(cardImage)
        contentView.addSubview(cardLabel)
        
        NSLayoutConstraint.activate([
            cardImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.835),
            cardLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.165)
        ])
    }
    
}
