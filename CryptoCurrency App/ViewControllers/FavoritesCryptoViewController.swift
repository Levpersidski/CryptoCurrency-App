//
//  FavoritesCryptoViewController.swift
//  CryptoCurrency App
//
//  Created by SWIFT on 18.04.2025.
//

import UIKit

class FavoritesCryptoViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.rowHeight = 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? DetailsViewController,
           let selectedCrypto = sender as? CryptoCurrency {
            detailsVC.crypto = selectedCrypto
            detailsVC.dateFormatter = DateFormatter.cryptoDateFormatter
        }
    }
    
    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FavoriteManager.shared.favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as? CryptoViewCell else {
            return UITableViewCell() }
        
        let crypto = FavoriteManager.shared.favorites[indexPath.row]
        cell.configure(with: crypto, isFavorite: true, showFavoriteButton: false)
           cell.configureButtonVisibility(isHidden: true)
           return cell
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let crypto = FavoriteManager.shared.favorites[indexPath.row]
        performSegue(withIdentifier: "detailsVC2", sender: crypto)
    }
}


