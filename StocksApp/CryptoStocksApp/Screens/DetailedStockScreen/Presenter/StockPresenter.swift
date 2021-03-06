//
//  StockPresenter.swift
//  StocksApp
//
//  Created by Arthur on 28.05.2022.
//

import UIKit

protocol StockViewProtocol: AnyObject {
    func updateView(with graphModel: GraphModel)
    func updateView(withLoader isLoading: Bool)
    func updateView(withError message: String)
}

protocol StockPresentProtocol {

    var favoriteButtonIsSelected: Bool { get }
    var title: String? { get }
    var symbol: String? { get }
    var currentPrice: String? { get }
    var priceChange: String? { get }
    var changeColor: UIColor? { get }
    var name: [String]? { get }
    var titleForBuyButton: String? { get }
    func favoriteButtonTapped()
    func loadView()

}

final class StockPresenter: StockPresentProtocol {
        
    weak var view: StockViewProtocol?
    
    private let model: StocksModelProtocol
    
    private let service: StocksServiceProtocol
    
    var graphModel: GraphModel
    
    
    var title: String? {
        model.name
    }
    
    var symbol: String? {
        model.symbol
    }
    
    var currentPrice: String? {
        model.price
    }

    var priceChange: String? {
        model.priceChanged
    }
    
    var changeColor: UIColor? {
        model.changeColor
    }
    
    var favoriteButtonIsSelected: Bool {
        model.isFavorite
    }
    
    var name: [String]? {
        graphModel.periods.map { $0.name }
    }
    
    var titleForBuyButton: String? {
        model.priceForBuyButton
    }
    
    init(model: StocksModelProtocol, service: StocksServiceProtocol, graphModel: GraphModel) {
        self.model = model
        self.service = service
        self.graphModel = graphModel
    }

    func loadView() {
        
        view?.updateView(withLoader: true)
        
        service.getCharts(id: model.id, currency: "usd", days: "365", isDaily: true) { [weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self?.view?.updateView(withLoader: false)
                
                switch result {
                case .success(let charts):
                    self?.view?.updateView(with: self?.graphModel.build(from: charts) ?? GraphModel(periods: []))
                case.failure(let error):
                    self?.view?.updateView(withError: error.localizedDescription)
                }
            }
        }
    }
    
    func favoriteButtonTapped() {
        model.setFavourite()
    }
}
