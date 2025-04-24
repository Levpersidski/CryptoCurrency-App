//
//  DetailsViewController.swift
//  CryptoCurrency App
//
//  Created by SWIFT on 18.04.2025.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var cryptoNameLabel: UILabel!
    
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var marketCapRankLabel: UILabel!
    
    @IBOutlet weak var aTHDateLabel: UILabel!
    @IBOutlet weak var aTLDateLabel: UILabel!
    
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var aTHPriceLabel: UILabel!
    @IBOutlet weak var aTLPriceLabel: UILabel!
    @IBOutlet weak var percentFromATLLabel: UILabel!
    @IBOutlet weak var PercentFromATHLabel: UILabel!
    
    @IBOutlet weak var low24HLabel: UILabel!
    @IBOutlet weak var high24Label: UILabel!
    
    var crypto: CryptoCurrency?
    
    
    var dateFormatter: DateFormatter?
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            loadData()
        }


        // MARK: - Load Data
        private func loadData() {
            guard let crypto = crypto else { return }

            cryptoNameLabel.text = crypto.name
            marketCapRankLabel.text = "Ранг: \(crypto.marketCapRank)"

            currentPriceLabel.text = format(crypto.currentPrice)
            aTHPriceLabel.text = format(crypto.aTHPrice)
            aTLPriceLabel.text = format(crypto.aTLPrice)
            marketCapLabel.text = format(crypto.marketCap)
            high24Label.text = format(crypto.high24H)
            low24HLabel.text = format(crypto.low24H)

            aTHDateLabel.text = formatted(date: crypto.aTHDate)
            aTLDateLabel.text = formatted(date: crypto.aTLDate)

            configurePercentLabel(value: crypto.percentFromATL, label: percentFromATLLabel)
            configurePercentLabel(value: crypto.athChangePercentage, label: PercentFromATHLabel)

            cryptoImage.loadImage(from: crypto.image)
        }

        // MARK: - UI Formatting
        private func format(_ value: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            return "$\(formatter.string(from: NSNumber(value: value)) ?? "0")"
        }

        private func configurePercentLabel(value: Double, label: UILabel) {
            let arrow = value >= 0 ? "📈" : "📉"
            label.text = String(format: "%.2f%% %@", value, arrow)
            label.textColor = value >= 0 ? .systemGreen : .systemRed
        }

        private func formatted(date: Date?) -> String {
            guard let date = date, let formatter = dateFormatter else {
                return "N/A"
            }
            return formatter.string(from: date)
        }
    }
