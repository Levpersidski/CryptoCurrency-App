//
//  CryptoTableViewCell.swift
//  CryptoCurrency App
//
//  Created by SWIFT on 18.04.2025.
//

import UIKit

protocol CryptoViewCellDelegate: AnyObject {
    
    func addToFavButtonTapped (for crypto: CryptoCurrency)
}

class CryptoViewCell: UITableViewCell {

    @IBOutlet weak var cryptoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToFavButton: UIButton!

    private var crypto: CryptoCurrency?
    weak var delegate: CryptoViewCellDelegate?

    func configure(with crypto: CryptoCurrency, isFavorite: Bool, showFavoriteButton: Bool) {
        self.crypto = crypto // чтобы делегат работал корректно
        
        nameLabel.text = crypto.name
        priceLabel.text = "$\(crypto.currentPrice)"

        // Кнопка избранного
        addToFavButton.isHidden = !showFavoriteButton
        let starImage = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        addToFavButton.setImage(starImage, for: .normal)

        // Загрузка изображения
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

    
    @IBAction func addToFavButtonTapped(_ sender: UIButton) {
            guard let crypto = crypto else { return }
            delegate?.addToFavButtonTapped(for: crypto)
        }
    func configureButtonVisibility(isHidden: Bool) {
        addToFavButton.isHidden = isHidden
    }
    }


