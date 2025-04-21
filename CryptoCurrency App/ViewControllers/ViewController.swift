//
//  ViewController.swift
//  CryptoCurrency App
//
//  Created by SWIFT on 18.04.2025.
//

import UIKit



var apiURL = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false")!

final class ViewController: UITableViewController, CryptoViewCellDelegate {

    var cryptos: [CryptoCurrency] = []
   
        
    override func viewDidLoad() {
            super.viewDidLoad()
            setupTableView()
            setupRefreshControl()
            fetchCrypto()
        }

    
        
        // MARK: - Setup
        private func setupTableView() {
            tableView.rowHeight = 60
        }
        
        private func setupRefreshControl() {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
        
        @objc private func refreshData() {
            fetchCrypto()
        }
        
        // MARK: - TableView DataSource
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cryptos.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as? CryptoViewCell else {
                return UITableViewCell()
            }
            
            let crypto = cryptos[indexPath.row]
            let isFavorite = FavoriteManager.shared.isFavorite(crypto)
            cell.configure(with: crypto, isFavorite: isFavorite, showFavoriteButton: true)
            cell.delegate = self
            cell.configureButtonVisibility(isHidden: false)
            return cell
        }
        
        // MARK: - TableView Delegate
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let crypto = cryptos[indexPath.row]
            performSegue(withIdentifier: "detailsVC", sender: crypto)
        }
        
        // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? DetailsViewController,
           let selectedCrypto = sender as? CryptoCurrency {
            detailsVC.crypto = selectedCrypto
            detailsVC.dateFormatter = DateFormatter.cryptoDateFormatter
        }
    }
        
        // MARK: - CryptoViewCellDelegate
    func addToFavButtonTapped(for crypto: CryptoCurrency) {
        let added = FavoriteManager.shared.toggleFavorite(crypto)
        if added {
            showAlert(title: "Добавлено", message: "\(crypto.name) добавлен(а) в избранное")
        } else {
            showAlert(title: "Удалено", message: "\(crypto.name) удален(а) из избранного")
        }
        tableView.reloadData()
    }
        
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            self.present(alert, animated: true) {
                // Автоматическое закрытие через 1 секунду
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    alert.dismiss(animated: true)
                }
            }
        }
    }
    }

    // MARK: - Networking
    extension ViewController {
        func fetchCrypto() {
            URLSession.shared.dataTask(with: apiURL) { [weak self] data, response, error in
                guard let self = self else { return }
                
                // Завершаем обновление независимо от результата
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
                
                if let error = error {
                    self.showError(error)
                    return
                }
                
                guard let data = data else {
                    self.showError(message: "No data received")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    
                    let cryptoCurrencies = try decoder.decode([CryptoCurrency].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.cryptos = cryptoCurrencies.sorted { $0.marketCapRank < $1.marketCapRank }
                        self.tableView.reloadData()
                    }
                } catch {
                    self.showError(error)
                }
            }.resume()
        }
        
        private func showError(_ error: Error) {
            showError(message: error.localizedDescription)
        }
        
        private func showError(message: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
        
    }

    // MARK: - DateFormatter Extension
    extension DateFormatter {
        static var cryptoDateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }
    }

