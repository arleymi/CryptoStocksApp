//
//  StockCell.swift
//  StocksApp
//
//  Created by Arthur Lee on 24.05.2022.
//

import UIKit

final class StockCell: UITableViewCell {
    
    private var favouriteAction: (() -> Void)?
    
    lazy var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: "Apple")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "AAPL"
        label.font = UIFont(name: "Montserrat", size: 18)
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var cryptoNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Apple Inc."
        label.font = UIFont(name: "Montserrat", size: 11)
        label.font = .boldSystemFont(ofSize: 11)
        return label
    }()
    
    lazy var starButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "starOff"), for: .normal)
        button.setImage(UIImage(named: "starOn") , for: .selected)
        button.addTarget(self, action: #selector(starButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var currentPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$131.93"
        label.font = UIFont(name: "Montserrat", size: 18)
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var changedPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+$0,12 (1,15%)"
        label.font = UIFont(name: "Montserrat", size: 12)
        label.font = .boldSystemFont(ofSize: 12)
        let color = UIColor(r: 36, g: 178, b: 93)
        label.textColor = color
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstrains()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favouriteAction = nil
    }
    
    func configure(with model: StocksModelProtocol) {
        symbolLabel.text = model.symbol
        cryptoNameLabel.text = model.name
        currentPriceLabel.text = model.price
        changedPriceLabel.text = model.priceChanged
        changedPriceLabel.textColor = { model.changeColor }()
        starButton.isSelected = model.isFavorite
        favouriteAction = {
            model.setFavourite()
        }
    }
    
    @objc func starButtonPressed(sender: UIButton) {
        sender.isSelected.toggle()
        favouriteAction?()
    }
    
    private func setUpViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(iconView)
        cellView.addSubview(symbolLabel)
        cellView.addSubview(cryptoNameLabel)
        cellView.addSubview(starButton)
        cellView.addSubview(currentPriceLabel)
        cellView.addSubview(changedPriceLabel)
    }
    
    
    private func setUpConstrains() {

        // CellView For spacing settings
        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        cellView.heightAnchor.constraint(equalToConstant: 68).isActive = true
        
        // Logo
        iconView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8).isActive = true
        iconView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8).isActive = true
        iconView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -8).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        
        // SymbLabel
        symbolLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12).isActive = true
        symbolLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 14).isActive = true
        
        // CorporationName label
        cryptoNameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12).isActive = true
        cryptoNameLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -14).isActive = true
        
        // StarButton
        starButton.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 6).isActive = true
        starButton.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16).isActive = true
        starButton.widthAnchor.constraint(equalToConstant: 16).isActive = true
        starButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        //Current Price Label
        currentPriceLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 14).isActive = true
        currentPriceLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -17).isActive = true
        
        //ChagedPrice Label
        changedPriceLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12).isActive = true
        changedPriceLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -14).isActive = true
    }
}