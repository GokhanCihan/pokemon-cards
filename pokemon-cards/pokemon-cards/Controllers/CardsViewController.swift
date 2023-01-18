//
//  ViewController.swift
//  pokemon-cards
//
//  Created by Gökhan on 8.11.2022.
//

import UIKit

class CardsViewController: UIViewController, UICollectionViewDelegate, UIGestureRecognizerDelegate{
    enum Section: CaseIterable {
        case main
    }
    
    var cardsCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Card>!
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let searchBar = UISearchBar(frame: .zero)
    var debounceWorkItem: DispatchWorkItem?
    var cards = [Card]()
    var smallCardImages = [UIImage]()
    var favoriteCards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLayoutHierachy()
        configureDataSource()
        loadFavorites()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /* Debouncing prevents firing searches continuously as user types. Waits for a specific
         time before calling the API. */
        debounceWorkItem?.cancel()
        if !(searchText.count < 2) {
            if Int(searchText) != nil {
                debounceWorkItem = DispatchWorkItem {
                    Task {
                        let callString = self.constructStringForAPICall(with: searchText)
                        self.cards = try await self.fetchCardData(for: callString)
                        for try await card in Cards(cards: self.cards){
                            if let image = try? await APIService(card.smallImageURLString).getImage(){
                                self.smallCardImages.append(image)
                            }
                        }
                        self.performSnapshot()
                    }
                }
                if let debounceWorkItem = debounceWorkItem {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: debounceWorkItem)
                }
            }
        }else {
            self.cards.removeAll(keepingCapacity: false)
            self.smallCardImages.removeAll(keepingCapacity: false)
            self.performSnapshot()
        }
    }
    
    func fetchCardData(for urlString: String) async throws -> [Card] {
        do {
            let cardData = try await APIService(urlString).getJSON(for: PokemonTCG.self)
            return mapResult(of: cardData.data)
        } catch {
            throw error
        }
    }
}

extension CardsViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<FilteredCardCell, Card> {
            (cell, indexPath, card) in
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
            longPressRecognizer.numberOfTouchesRequired = 1
            longPressRecognizer.minimumPressDuration = 0.5
            longPressRecognizer.delegate = self
            cell.addGestureRecognizer(longPressRecognizer)
            cell.cardImage.image = self.smallCardImages[indexPath.item]
            cell.cardLabel.text = card.name
            cell.imageURLString = card.smallImageURLString
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Card>(collectionView: cardsCollectionView) {
        (collectionView: UICollectionView,
         indexPath: IndexPath,
         itemIdentifier: Card) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    // Update interface as data changed
    func performSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Card>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cards)
        dataSource.apply(snapshot, animatingDifferences: true)
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
    
    func constructStringForAPICall(with searchText: String) -> String {
        return "https://api.pokemontcg.io/v2/cards?q=hp:[" + searchText
        + "%20TO%20" + searchText + "]&orderBy=hp&pageSize=50"
    }
    
    // Initialize card objects from returnes card data
    func mapResult(of cardData: [CardData]) -> [Card] {
        cardData.map{ Card(id: $0.id,
                           name: $0.name,
                           artist: $0.artist,
                           smallImageURLString: $0.images.small,
                           largeImageURLString: $0.images.large)
        }
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            if let pressedView = sender.view as? FilteredCardCell{
                if let cardName = pressedView.cardLabel.text {
                    self.addFavorites(with: cardName)
                }
            }
            sender.state = .ended
        default:
            break
        }
    }
    
    func addFavorites(with cardName: String) {
        // Check if card is already in favorites
        for card in self.favoriteCards{
            if card.name != cardName {
                continue
            }else{
                self.favoriteCards.append(card)
                self.updateDefaults()
                break
            }
        }
    }
}

extension CardsViewController {
    // Call detail view for tapped card
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        guard let tappedCard = self.dataSource.itemIdentifier(for: indexPath) else { return }
        vc.name = tappedCard.name
        vc.artist = tappedCard.artist
        vc.largeImageString = tappedCard.largeImageURLString
        collectionView.deselectItem(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CardsViewController {
    // Save favorite card image(?) into userdefaults
    func updateDefaults() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(self.favoriteCards) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "favoriteCards")
        }else{
            print("save failed")
        }
    }
    
    // Load favorite card image from userdefaults
    func loadFavorites() {
        let defaults = UserDefaults.standard
        if let loadData = defaults.object(forKey: "favoriteCards") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                self.favoriteCards = try jsonDecoder.decode([Card].self, from: loadData)
            } catch {
                print("Load failed")
            }
        }
    }
}

