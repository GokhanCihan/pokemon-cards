//
//  FavoritesCollectionViewController.swift
//  pokemon-cards
//
//  Created by Gökhan on 30.12.2022.
//

import UIKit

class FavoritesCollectionViewController: UICollectionViewController {
    
    enum Section: CaseIterable {
        case main
    }
    var favoritesCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Card>!
    var favoriteCards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        Task {
            configureLayoutHierachy()
            configureDataSource()
        }
    }
}

extension FavoritesCollectionViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<FilteredCardCell, Card> {
            (cell, indexPath, card) in
            cell.cardImage.image = UIImage(named: "not found")
            cell.cardLabel.text = card.name
        }
        dataSource = UICollectionViewDiffableDataSource<Section, Card>(collectionView: favoritesCollectionView) {
        (collectionView: UICollectionView,
         indexPath: IndexPath,
         itemIdentifier: Card) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    func applySnapshot(with filter: Int) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Card>()
        snapshot.appendSections([.main])
        snapshot.appendItems(favoriteCards)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension FavoritesCollectionViewController {
    func createLayout() -> UICollectionViewLayout {
        let smallImageHeight = CGFloat(342)
        let smallImageWidth = CGFloat(245)
        let itemWidth = smallImageWidth
        let itemHeight = smallImageHeight / 0.835
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = contentSize.width / itemWidth
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                                  heightDimension: .absolute(itemHeight))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(itemHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: Int(columns))
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: CGFloat(0), bottom: spacing, trailing: CGFloat(0))
            return section
        }
        return layout
    }
    func configureLayoutHierachy() {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.isUserInteractionEnabled = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        self.favoritesCollectionView = collectionView
    }
}
//extension FavoritesCollectionViewController {
//    func loadFavorites() {
//        let defaults = UserDefaults.standard
//        
//            
//    }
//}

