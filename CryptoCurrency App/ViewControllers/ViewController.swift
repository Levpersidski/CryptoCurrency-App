//
//  ViewController.swift
//  CryptoCurrency App
//
//  Created by SWIFT on 18.04.2025.
//

import UIKit



var url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false")!

final class ViewController: UITableViewController {
   
    var cryptos: [CryptoCurrency] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        fetchCrypto()
    }
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cryptos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as? CryptoTableViewCell else {
               return UITableViewCell()
           }

        let crypto = cryptos[indexPath.row]
            cell.configure(with: crypto)
            cell.delegate = self
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt \(indexPath)")
    }
}


// MARK: - Networking
extension ViewController {
    func fetchCrypto() {
        URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
            guard let data else{
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            
            do {
            let cryptoCurrencies = try decoder.decode([CryptoCurrency].self, from: data)
                DispatchQueue.main.async {
                    self.cryptos = cryptoCurrencies.sorted(by: { $0.marketCupRank < $1.marketCupRank })
                    self.tableView.reloadData()
                    print(cryptoCurrencies)
                }
            } catch {
                print (error)
            }
        }.resume()
        
    }
    
}

extension ViewController: CryptoCellDelegate {
    func didTapMoreButton(for crypto: CryptoCurrency) {
        let alert = UIAlertController(title: crypto.name, message: "Цена: $\(crypto.currentPrice)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    
}
