//
//  FavoritesStocksViewController.swift
//  StocksApp
//
//  Created by Arthur Lee on 01.06.2022.
//

import UIKit

final class FavoritesStocksViewController: UIViewController {
    
    private var presenter: FavoriteStocksPresenterProtocol
    
    init(presenter: FavoriteStocksPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StockCell.self, forCellReuseIdentifier: StockCell.typeName)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadView()
    }
    

    private func setUpTableView() {
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Favorites"
    }
   
    private func setUpSubViews() {
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}

extension FavoritesStocksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.typeName, for: indexPath) as? StockCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if indexPath.row.isMultiple(of: 2) {
            cell.cellView.backgroundColor = UIColor.CustomColors.customLightGray
        } else {
            cell.cellView.backgroundColor = .white
        }
        cell.configure(with: presenter.model(for: indexPath.row))
        return cell
    }
}

extension FavoritesStocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.moveToDetailedScreen(at: indexPath.row)
    }
}

extension FavoritesStocksViewController: FavoriteStocksViewProtocol {
    
    func updateView() {
        tableView.reloadData()
    }

    func updateView(withLoader isLoading: Bool) {
    }
    
    func updateView(withError message: String) {
    }
    
}
