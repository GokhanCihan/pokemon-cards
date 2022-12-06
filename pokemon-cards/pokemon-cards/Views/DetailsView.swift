//
//  DetailsView.swift
//  pokemon-cards
//
//  Created by Gökhan on 6.12.2022.
//

import UIKit

class DetailsView: UIView {
    var view = DetailsView()
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
        view.translatesAutoresizingMaskIntoConstraints = false
        largeImageView.translatesAutoresizingMaskIntoConstraints = false
        largeImageView.contentMode = .scaleAspectFit
        
        cardNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardNameLabel.adjustsFontForContentSizeCategory = true
        cardNameLabel.textAlignment = .center
        
        cardArtistLabel.translatesAutoresizingMaskIntoConstraints = false
        cardArtistLabel.adjustsFontForContentSizeCategory = true
        cardArtistLabel.textAlignment = .center
        
        frame = bounds
        addSubview(view)
        view.addSubview(largeImageView)
        view.addSubview(cardNameLabel)
        view.addSubview(cardArtistLabel)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            largeImageView.topAnchor.constraint(equalTo: view.topAnchor),
            largeImageView.heightAnchor.constraint(equalToConstant: CGFloat(495)),
            largeImageView.widthAnchor.constraint(equalToConstant: CGFloat(360)),
            largeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cardNameLabel.topAnchor.constraint(equalTo: largeImageView.bottomAnchor),
            cardNameLabel.heightAnchor.constraint(equalToConstant: CGFloat(50)),
            cardNameLabel.leadingAnchor.constraint(equalTo: largeImageView.leadingAnchor),
            cardNameLabel.trailingAnchor.constraint(equalTo: largeImageView.trailingAnchor),

            cardArtistLabel.topAnchor.constraint(equalTo: cardNameLabel.bottomAnchor),
            cardArtistLabel.heightAnchor.constraint(equalToConstant: CGFloat(50)),
            cardArtistLabel.leadingAnchor.constraint(equalTo: cardNameLabel.leadingAnchor),
            cardArtistLabel.trailingAnchor.constraint(equalTo: cardNameLabel.trailingAnchor),
        ])
    }
}
