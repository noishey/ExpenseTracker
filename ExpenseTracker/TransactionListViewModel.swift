//
//  TransactionListViewModel.swift
//  ExpenseTracker
//
//  Created by Arjun Shenoy on 15/12/25.
//

import Foundation
import Combine

final class TransactionListViewModel: ObservableObject{
    @Published var transaction: [Transaction] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        getTransactions()
    }
    func getTransactions() {
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invalid URL")
            return
        }
        
        // Configure a decoder that converts snake_case keys to camelCase properties.
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Transaction].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error Fetching Transactions:", error.localizedDescription)
                case .finished:
                    print("Finished Fetching Transactions")
                }
            } receiveValue: { [weak self] result in
                self?.transaction = result
                dump(self?.transaction)
            }
            .store(in: &self.cancellables)
    }
}
