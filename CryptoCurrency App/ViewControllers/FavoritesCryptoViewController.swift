//
//  FavoritesCryptoViewController.swift
//  CryptoCurrency App
//
//  Created by SWIFT on 18.04.2025.
//

import UIKit

class FavoritesCryptoViewController: UITableViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? DetailsViewController,
           let selectedCrypto = sender as? CryptoCurrency {
            detailsVC.crypto = selectedCrypto
            detailsVC.dateFormatter = DateFormatter.cryptoDateFormatter
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let crypto = FavoriteManager.shared.favorites[indexPath.row]
        performSegue(withIdentifier: "detailsVC2", sender: crypto)
    }
}


