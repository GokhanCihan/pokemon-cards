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
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cardImage)
        contentView.addSubview(cardLabel)
        
        cardLabel.adjustsFontForContentSizeCategory = true
        let inset = CGFloat(10)
        
        NSLayoutConstraint.activate([
            cardImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.835),
            cardLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            cardLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            cardLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.165)
        ])
    }
}
