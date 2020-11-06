//
//  HomeViewController.swift
//  POCApp
//
//  Created by Ritesh on 05/11/20.
//  Copyright © 2020 Ritesh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let networkHandler = NetworkHandler()
    var rowData = [Row]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchHomeData()
    }

    func fetchHomeData() {
        networkHandler.fetchHomeDetails { (homeData, error) in
            DispatchQueue.main.async {
                guard let homeData = homeData else {
                    self.showAlert(withMessage: "Request Failed")
                    return
                }
                self.displayHomeData(data: homeData)
            }
        }
    }
    
    func displayHomeData(data: Home) {
        title = data.title
        rowData = data.rows
        tableView.reloadData()
    }
    
    func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func fetchImage(indexPath: IndexPath) {
        let imageURL = rowData[indexPath.row].imageURL ?? ""
        if let url = URL(string: imageURL) {
            networkHandler.fetchWikiImage(url: url) { [unowned self] (image, error) in
                DispatchQueue.main.async {
                    guard let image = image else {
                        return
                    }
                    self.rowData[indexPath.row].image = image
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeRow", for: indexPath) as? HomeTableViewCell else {
            return HomeTableViewCell()
        }
        setupCell(atIndexPath: indexPath, cell: cell)
        return cell
    }
    
    func setupCell(atIndexPath indexPath: IndexPath, cell: HomeTableViewCell) {
        let row = rowData[indexPath.row]
        cell.titleLabel.text = row.title
        cell.descriptionLabel.text = row.rowDescription
        cell.wikiImageView.image = row.image
        if cell.wikiImageView.image == nil {
            fetchImage(indexPath: indexPath)
        }
    }
}
