//
//  CanadaFactsTests.swift
//  CanadaFactsTests
//
//  Created by Kiran Chowdary on 8/4/18.
//  Copyright © 2018 Kiran Chowdary. All rights reserved.
//

import XCTest
import SnapKit
import Kingfisher

@testable import CanadaFacts

class CanadaFactsTests: XCTestCase {
    
    let factvc = FactsTableViewController()
    var session: URLSession!
    override func setUp() {
        super.setUp()
       self.initialise()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }

    
    //Testing View loading
    func testViewLoads() {
        XCTAssertNotNil(self.factvc.view, "The View is not initiated properly")
    }
    func testMainViewHasFactTableViewSubview() {
        XCTAssertTrue((self.factvc.tableView != nil), "TableView is not present in the view")
    }
    func testFactTableViewLoads() {
        XCTAssertNotNil(self.factvc.tableView, "TableView not initiated")
    }
    //Testing UITableView
    func testFactViewConformsToUITableViewDelegateAndDataSource() {
       
        XCTAssertNotNil(self.factvc.tableView.dataSource, "Datasource of table cannot be nil")
        XCTAssertTrue(self.factvc.conforms(to: UITableViewDataSource.self),
                      "View doesn't conform to TableView datasource protocol")
    }
    
    func testFactTableViewCellCreateCellsWithReuseIdentifier() {
        let indexPath = IndexPath(row: 0, section: 0)
        var cell = self.factvc.tableView.cellForRow(at: indexPath) as? TableViewCell
        if cell == nil {
            cell = self.factvc.tableView.dequeueReusableCell(withIdentifier:
                TableViewCell.reuseIdentifier) as? TableViewCell
        }
        let expectedReuseIdentifier = TableViewCell.reuseIdentifier
        XCTAssertTrue(cell?.reuseIdentifier == expectedReuseIdentifier, "Table does not have reusable cells")
    }
    
    
    // Testing Internet Connection
    func testInternetConnectivity() {
        if Reachability.isConnectedToNetwork() {
            XCTAssertTrue(Reachability.isConnectedToNetwork(), " Network connection is not Available")
            XCTAssertFalse(!Reachability.isConnectedToNetwork(), "Network connection Available")
        }
    }
    
    
    //Testing URLSession asynchronous request
    func testCallToGetsHTTPProperStatusCode() {
        if Reachability.isConnectedToNetwork() {
            let url = URL(string: URL_STRING)
            let originalValue = expectation(description: STATUS_OK_CODE)
            session = URLSession(configuration: URLSessionConfiguration.default)
            let dataTask = session.dataTask(with: url!) { data, response, error in
                if let error = error {
                    XCTFail("Error: \(error.localizedDescription)")
                    return
                } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode == 200 {
                        originalValue.fulfill()
                    } else {
                        XCTFail("Status code: \(statusCode)")
                    }
                }
            }
            dataTask.resume()
            waitForExpectations(timeout: 5, handler: nil)
        }
    }
    
    func initialise()
    {
        let tableViewController = FactsTableViewController()
        let navigationController = UINavigationController.init(rootViewController: tableViewController)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = navigationController
        self.factvc.performSelector(onMainThread: #selector(factvc.viewDidLoad),
                                    with: nil, waitUntilDone: true)
        
    }
    
}
