//
//  DetailsViewController.swift
//  pokemon-cards
//
//  Created by Gökhan on 6.12.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    var detailsView = DetailsView()
    var largeImageString: String?
    var name: String?
    var artist: String?
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubview(detailsView)

        title = "Details"
        NSLayoutConstraint.activate([
            detailsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 10)
        ])
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var largeImage = UIImage()
        
        Task {
            if let largeImageString {
                largeImage = try! await fetchImage(urlString: largeImageString)
            }
            detailsView.largeImageView.image = largeImage
            detailsView.cardNameLabel.text = "Name: \(name!)"
            detailsView.cardArtistLabel.text = "Artist: \(artist!)"
        }
    }
    
    func fetchImage(urlString: String) async throws -> UIImage {
        guard
            let url = URL(string: urlString)
        else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "X-Api-Key": "e61fbaee-7eaa-4759-9818-77b6f4ea2bac"
        ]
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        guard
            let httpResponse = urlResponse as? HTTPURLResponse,
                httpResponse.statusCode == 200
        else {
            throw APIError.invalidResponse
        }
        if let image = UIImage(data: data){
            return image
        }else {
            return UIImage(named: "notFound")!
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
