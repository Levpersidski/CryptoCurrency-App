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
          setupUI()
          loadData()
          loadImage()
          
      }
      
      private func setupUI() {
          // Настройка внешнего вида изображения
          cryptoImage.layer.cornerRadius = 12
          cryptoImage.clipsToBounds = true
          cryptoImage.contentMode = .scaleAspectFit
      }
      
      private func loadData() {
          guard let crypto = crypto else { return }
          
          // Основная информация
          cryptoNameLabel.text = crypto.name
          marketCapRankLabel.text = "Ранг: \(crypto.marketCapRank)"
          
          // Форматирование чисел
          let numberFormatter = NumberFormatter()
          numberFormatter.numberStyle = .decimal
          numberFormatter.maximumFractionDigits = 2
          
          // Цены
          currentPriceLabel.text = "$\(numberFormatter.string(from: NSNumber(value: crypto.currentPrice)) ?? "0")"
          aTHPriceLabel.text = "$\(numberFormatter.string(from: NSNumber(value: crypto.aTHPrice)) ?? "0")"
          aTLPriceLabel.text = "$\(numberFormatter.string(from: NSNumber(value: crypto.aTLPrice)) ?? "0")"
          
          // Рыночная капитализация
          marketCapLabel.text = "$\(numberFormatter.string(from: NSNumber(value: crypto.marketCap)) ?? "0")"
          
          // Проценты
          configurePercentLabel(value: crypto.percentFromATL, label: percentFromATLLabel)
          configurePercentLabel(value: crypto.athChangePercentage, label: PercentFromATHLabel)
          // 24h диапазон
          high24Label.text = "$\(numberFormatter.string(from: NSNumber(value: crypto.high24H)) ?? "0")"
          low24HLabel.text = "$\(numberFormatter.string(from: NSNumber(value: crypto.low24H)) ?? "0")"
          
          // Даты
          aTHDateLabel.text = formatted(date: crypto.aTHDate)
          aTLDateLabel.text = formatted(date: crypto.aTLDate)
      }
      
      private func loadImage() {
          guard let crypto = crypto else { return }
          
          cryptoImage.image = UIImage(systemName: "photo") // Плейсхолдер
          
          if let url = URL(string: crypto.image) {
              URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                  if let data = data, let image = UIImage(data: data) {
                      DispatchQueue.main.async {
                          self?.cryptoImage.image = image
                      }
                  }
              }.resume()
          }
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
