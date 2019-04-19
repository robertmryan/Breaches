//
//  ViewController.swift
//  Breaches
//
//  Created by Robert Ryan on 4/18/19.
//  Copyright © 2019 Robert Ryan. All rights reserved.
//

import UIKit

class BreachViewController: UITableViewController {
    var viewModel = BreachViewModel(model: nil)
    var dimmingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tell view model what you want it to do when the model changes
        
        viewModel.breachesDidChange = { [weak self] result in
            self?.tableView.reloadData()
        }
        
        // tell view model that you want it to fetch from the server
        
        showHUD()
        viewModel.fetchBreaches { [weak self] result in
            self?.removeHUD()
            if case .failure(let error) = result {
                self?.showError(error)
            }
        }
    }
    
    @IBAction func didTapToggleButton(_ sender: Any) {
        switch viewModel.sortedBy {
        case .name: viewModel.sortedBy = .date
        case .date: viewModel.sortedBy = .name
        }
    }
}

// MARK: - UITableViewDataSource

extension BreachViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breaches?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.breaches?[indexPath.row].name
        cell.detailTextLabel?.text = viewModel.breaches?[indexPath.row].breachDate.map { viewModel.string(for: $0) } ?? "No date provided"
        return cell
    }
}

// MARK: - Private methods

private extension BreachViewController {
    // you'd obviously want to do something more than just showing the localizedDescription, but this illustrates the idea
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert"), style: .default))
        present(alert, animated: true)
    }
    
    func showHUD() {
        let dimmingView = UIView(frame: view.bounds)
        dimmingView.backgroundColor = .darkGray
        view.addSubview(dimmingView)
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: dimmingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: dimmingView.centerYAnchor)
        ])
        activityIndicator.startAnimating()
        self.dimmingView = dimmingView
    }
    
    func removeHUD() {
        dimmingView?.removeFromSuperview()
    }
}
