//
//  FavoritesPresenter.swift
//  StocksApp
//
//  Created by Arthur Lee on 01.06.2022.
//

import UIKit

protocol FavoriteStocksViewProtocol: AnyObject {
    func updateView()
    func updateView(withLoader isLoading: Bool)
    func updateView(withError message: String)
}


protocol FavoriteStocksPresenterProtocol {
    var view: FavoriteStocksViewProtocol? { get set }
    var stocks: [StocksModelProtocol] { get }
    var itemCount: Int { get }
    func loadView()
    func model(for indexPath: Int) -> StocksModelProtocol
    func moveToDetailedScreen(at index: Int)
}

final class FavoriteStocksPresenter: FavoriteStocksPresenterProtocol {
    
    private let service: StocksServiceProtocol
    
    var stocks: [StocksModelProtocol] = []
    
    var coordinator: CoordinatorProtocol?
    
    var itemCount: Int {
        stocks.count
    }

    init(service: StocksServiceProtocol) {
        self.service = service
    }
    
    weak var view: FavoriteStocksViewProtocol?
    
    func loadView() {
        view?.updateView(withLoader: true)
        
// Getting back with data and delete loader
        service.getStocks { [weak self] result in
            self?.view?.updateView(withLoader: false)
            
            switch result {
            case .success(let stocks):
                let allStocks = stocks
                self?.stocks = allStocks.filter { $0.isFavorite }
                self?.view?.updateView()
            case .failure(let error):
                self?.view?.updateView(withError: error.localizedDescription)
            }
        }
    }
    
    func model(for indexPath: Int) -> StocksModelProtocol {
        stocks[indexPath]
    }
    
    func moveToDetailedScreen(at index: Int) {
        coordinator?.moveFromFavoriteStocks(with: model(for: index))
    }
    
}
