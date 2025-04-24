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
            self.crypto = crypto

            nameLabel.text = crypto.name
            priceLabel.text = "$\(crypto.currentPrice)"

            // Favorite button config
            addToFavButton.isHidden = !showFavoriteButton
            let starImage = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            addToFavButton.setImage(starImage, for: .normal)

            // Image loading using extension
            cryptoImageView.loadImage(from: crypto.image)
            cryptoImageView.layer.cornerRadius = 8
            cryptoImageView.clipsToBounds = true
        }

        // MARK: - Button Action
        @IBAction func addToFavButtonTapped(_ sender: UIButton) {
            guard let crypto = crypto else { return }
            delegate?.addToFavButtonTapped(for: crypto)
        }

        // MARK: - Button Visibility
        func configureButtonVisibility(isHidden: Bool) {
            addToFavButton.isHidden = isHidden
        }
    }


