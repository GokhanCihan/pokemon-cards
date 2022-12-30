//
//  ViewController.swift
//  pokemon-cards
//
//  Created by Gökhan on 8.11.2022.
//

import UIKit

class CardsViewController: UIViewController, UICollectionViewDelegate, URLSessionDelegate , UIGestureRecognizerDelegate{
    
    enum Section: CaseIterable {
        case main
    }
    let cardsController = CardsController()
    var cardsCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, CardsController.Card>!
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let searchBar = UISearchBar(frame: .zero)
    var cards = [CardsController.Card]()
    var filteredCards = [CardsController.Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        Task {
            configureLayoutHierachy()
            configureDataSource()
            cards = try await fetchCardData()
        }
    }
    @MainActor
    func fetchCardData() async throws -> [CardsController.Card] {
        let apiService = APIService(urlString: "https://api.pokemontcg.io/v2/cards?page=1&pageSize=5")
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
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
            longPressRecognizer.numberOfTouchesRequired = 1
            longPressRecognizer.minimumPressDuration = 0.5
            longPressRecognizer.delegate = self
            cell.addGestureRecognizer(longPressRecognizer)
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
        collectionView.isUserInteractionEnabled = true
        
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
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        self.cardsCollectionView = collectionView
        
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

extension CardsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        guard let tappedCard = self.dataSource.itemIdentifier(for: indexPath) else { return }
        vc.name = tappedCard.name
        vc.artist = tappedCard.artist
        vc.largeImageString = tappedCard.largeImage
        collectionView.deselectItem(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CardsViewController {
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            if let pressedView = sender.view as? FilteredCardCell{
                if let cardName = pressedView.cardLabel.text {
                    self.addFavorites(cardName: cardName)
                }
            }
            sender.state = .ended
        default:
            break
        }
    }
    
    func addFavorites(cardName: String) {
        for card in cards {
            if card.name == cardName {
                saveFavorites(CardImage: card.smallImage, cardName: card.name)
                break
            }
        }
    }
    
    func saveFavorites(CardImage: UIImage, cardName: String) {
        DispatchQueue.global(qos: .background).async {
            let data = CardImage.jpegData(compressionQuality: 1.0)
            
            DispatchQueue.main.async {
                let defaults = UserDefaults.standard
                defaults.set(data, forKey: cardName)
            }
        }
    }
}

