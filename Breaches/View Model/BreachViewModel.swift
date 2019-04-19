//
//  BreachViewModel.swift
//  Breaches
//
//  Created by Robert Ryan on 4/18/19.
//  Copyright © 2019 Robert Ryan. All rights reserved.
//

import Foundation

class BreachViewModel {

    // MARK: - Properties
    
    var breaches: [Breach]? {
        didSet { breachesDidChange?(breaches) }
    }
    
    var sortedBy: SortedBy = .name {
        didSet {
            breaches = breaches.map { sort($0) }
        }
    }
    
    var breachesDidChange: (([Breach]?) -> Void)?
    
    let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Initialization
    
    init(model: [Breach]?) {
        breaches = model
    }
}

// MARK: - Public methods

extension BreachViewModel {
    func fetchBreaches(completion: @escaping (Result<[Breach], Error>) -> Void) {
        ApiManager.shared.fetchBreaches { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.breaches = nil
                
            case .success(let breaches):
                self.breaches = self.sort(breaches)
            }
            
            completion(result)
        }
    }
    
    func string(for date: Date?) -> String? {
        return date.map { dateOnlyFormatter.string(from: $0) }
    }
}

// MARK: - Private methods

private extension BreachViewModel {
    func sort(_ breaches: [Breach]) -> [Breach] {
        switch sortedBy {
        case .date: return breaches.sorted { $0.breachDateString < $1.breachDateString }
        case .name: return breaches.sortedByName()
        }
    }
}

// MARK: - Enumerations

extension BreachViewModel {
    enum BreachError: Error {
        case noData
    }
    
    enum SortedBy {
        case name
        case date
    }
}
