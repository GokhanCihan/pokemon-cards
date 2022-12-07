//
//  DetailsView.swift
//  pokemon-cards
//
//  Created by Gökhan on 6.12.2022.
//

import UIKit

class DetailsView: UIView {
    let largeImageView = UIImageView()
    let cardNameLabel = UILabel()
    let cardArtistLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension DetailsView {
    func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        largeImageView.translatesAutoresizingMaskIntoConstraints = false
        largeImageView.contentMode = .scaleAspectFit
        
        cardNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardNameLabel.adjustsFontForContentSizeCategory = true
        cardNameLabel.textAlignment = .center
        
        cardArtistLabel.translatesAutoresizingMaskIntoConstraints = false
        cardArtistLabel.adjustsFontForContentSizeCategory = true
        cardArtistLabel.textAlignment = .center
        
        self.addSubview(largeImageView)
        self.addSubview(cardNameLabel)
        self.addSubview(cardArtistLabel)

        NSLayoutConstraint.activate([
            largeImageView.topAnchor.constraint(equalTo: self.topAnchor),
            largeImageView.heightAnchor.constraint(equalToConstant: CGFloat(495)),
            largeImageView.widthAnchor.constraint(equalToConstant: CGFloat(360)),
            largeImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            cardNameLabel.topAnchor.constraint(equalTo: largeImageView.bottomAnchor),
            cardNameLabel.heightAnchor.constraint(equalToConstant: CGFloat(70)),
            cardNameLabel.leadingAnchor.constraint(equalTo: largeImageView.leadingAnchor),
            cardNameLabel.trailingAnchor.constraint(equalTo: largeImageView.trailingAnchor),

            cardArtistLabel.topAnchor.constraint(equalTo: cardNameLabel.bottomAnchor),
            cardArtistLabel.heightAnchor.constraint(equalToConstant: CGFloat(70)),
            cardArtistLabel.leadingAnchor.constraint(equalTo: cardNameLabel.leadingAnchor),
            cardArtistLabel.trailingAnchor.constraint(equalTo: cardNameLabel.trailingAnchor)
        ])
    }
}
