//
//  Transaction.swift
//


struct Transaction {

    let title: String
    let transactionAmount: String
    let transactionDate: String

    
    init(title: String, transactionAmount: String, transactionDate: String ) {
        self.title = title
        self.transactionAmount = transactionAmount
        self.transactionDate = transactionDate
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case transactionAmount = "transaction_amount"
        case transactionDate = "transaction_date"
    
    }
}
