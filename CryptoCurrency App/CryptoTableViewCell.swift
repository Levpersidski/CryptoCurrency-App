//
//  CryptoTableViewCell.swift
//  CryptoCurrency App
//
//  Created by SWIFT on 18.04.2025.
//

import UIKit

protocol CryptoCellDelegate: AnyObject {
    func didTapMoreButton(for crypto: CryptoCurrency)
}

class CryptoTableViewCell: UITableViewCell {

    @IBOutlet weak var cryptoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

    weak var delegate: CryptoCellDelegate?
    private var crypto: CryptoCurrency?

    func configure(with crypto: CryptoCurrency) {
        self.crypto = crypto
        nameLabel.text = crypto.name
        priceLabel.text = "$\(crypto.currentPrice)"
        cryptoImageView.image = UIImage(systemName: "photo") // placeholder

        if let url = URL(string: crypto.image) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.cryptoImageView.image = image
                    }
                }
            }.resume()
        }
    }

    @IBAction func moreButtonTapped(_ sender: UIButton) {
        guard let crypto = crypto else { return }
        delegate?.didTapMoreButton(for: crypto)
    }
}
