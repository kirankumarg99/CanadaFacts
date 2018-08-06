//
//  FactsTableViewController.swift
//  CanadaFacts
//
//  Created by Kiran Chowdary on 8/4/18.
//  Copyright © 2018 Kiran Chowdary. All rights reserved.
//



import UIKit
import SnapKit

class FactsTableViewController: UITableViewController {
    let dataFetch = NetworkAPI()
    var factData: FactInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 999
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.allowsSelection = false
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        loadData()
    }
    
    @objc func loadData() {
        self.refreshControl?.beginRefreshing()
        if !Reachability.isConnectedToNetwork(){
            displayAlertMsg(with: NO_CONNECTION)
        }
        
        dataFetch.fetchData { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
            }
            switch result {
            case .success(var factObj):
                
                factObj.facts = factObj.facts.filter() {
                    return $0.title != nil
                }
                self?.factData = factObj
                DispatchQueue.main.async {
                    self?.title = factObj.title
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func displayAlertMsg(with message: String) {
        let alertController = UIAlertController(title: NAME_OF_THE_ALERT, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return factData?.facts.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath)
        guard
            let cell = tableViewCell as? TableViewCell,
            let fact = factData?.facts[indexPath.row]
            else { return tableViewCell }
        
        cell.displayData(fact)
        return cell
    }
    
}

