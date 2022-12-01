//
//  ViewController.swift
//  pokemon-cards
//
//  Created by Gökhan on 8.11.2022.
//

import UIKit

class CardsViewController: UIViewController, UICollectionViewDelegate, URLSessionDelegate {
    
    enum Section: CaseIterable {
        case main
    }
    let cardsController = CardsController()
    var cardsCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, CardsController.Card>!
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let searchBar = UISearchBar(frame: .zero)
    var cards = [CardsController.Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            configureLayoutHierachy()
            configureDataSource()
            cards = try await fetchCardData()
        }
    }
    @MainActor
    func fetchCardData() async throws -> [CardsController.Card] {
        let apiService = APIService(urlString: "https://api.pokemontcg.io/v2/cards?page=1&pageSize=10")
        do {
            let fetchedResult = try await apiService.getJSON()
            return fetchedResult
        } catch {
            throw error
        }
    }
}

extension CardsViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<FilteredCardCell, CardsController.Card> {
            (cell, indexPath, card) in
            cell.cardImage.image = card.smallImage
            cell.cardLabel.text = card.name
        }
        dataSource = UICollectionViewDiffableDataSource<Section, CardsController.Card>(collectionView: cardsCollectionView) {
        (collectionView: UICollectionView,
         indexPath: IndexPath,
         itemIdentifier: CardsController.Card) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    func performQuery(with filter: Int) {
        var filteredCards = [CardsController.Card]()
        filteredCards = filterCards(with: filter).sorted{ $0.hp < $1.hp }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CardsController.Card>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredCards)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    func filterCards(with filter: Int) -> [CardsController.Card] {
        return cards.filter { $0.isEqualOrGreater(filter) }
    }
}

extension CardsViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let smallImageHeight = CGFloat(342)
            let smallImageWidth = CGFloat(245)
            let itemWidth = smallImageWidth
            let itemHeight = smallImageHeight / 0.835
            
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
            
            print("contentSize(width: \(contentSize.width), height: \(contentSize.height))")// Sil
            print("groupSize(width: \(group.layoutSize.widthDimension.dimension), height: \(group.layoutSize.heightDimension.dimension))")
            print("itemSize(width: \(item.layoutSize.widthDimension.dimension), height: \(item.layoutSize.heightDimension.dimension))")
            return section
        }
        return layout
    }
    func configureLayoutHierachy() {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        cardsCollectionView = collectionView
        
        searchBar.delegate = self
    }
}
extension CardsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchText.count < 2) {
            if let searchText = Int(searchText) {
                performQuery(with: searchText)
            }
        }else {
            performQuery(with: 1000)
        }
    }
}
