//
//  BankingProtocol.swift
//  BankingApp
//
//  Created by Vali Zairov on 9/5/25.
//

protocol BankingProtocol {
    /* Returns false if account already exists */
    func createAccount(_ accountId: String, _ timestamp: Int) -> Bool
    
    /* Returns total amount if deposit is successful */
    func deposit(to accountId: String, _ amount: Int) -> Int?
    
    /* Returns Source account total amount if transfer is successful */
    func transfer(_ timestamp: Int, _ sourceAccountId: String, _ targetAccountId: String, _ amount: Int) -> Int?
}

final class BankingImplementation: BankingProtocol {
    
    struct BankAccount: Hashable {
        let accountId: String
        let timestamp: Int
        var amount: Int = 0
    }
    
    var bankAccounts = [String: BankAccount]()
    
    private func accountExists(_ accountId: String) -> Bool {
        if bankAccounts[accountId] == nil {
            return false
        } else {
            return true
        }
    }
    
    func createAccount(_ accountId: String, _ timestamp: Int) -> Bool {
        guard !accountExists(accountId) else { return false }
        let account = BankAccount(accountId: accountId, timestamp: timestamp)
        bankAccounts[accountId] = account
        return true
    }
    
    func deposit(to accountId: String, _ amount: Int) -> Int? {
        guard accountExists(accountId), amount >= 0 else { return nil }
        bankAccounts[accountId]?.amount += amount
        return bankAccounts[accountId]?.amount
    }
    
    func transfer(_ timestamp: Int, _ sourceAccountId: String, _ targetAccountId: String, _ amount: Int) -> Int? {
        guard accountExists(sourceAccountId),
                accountExists(targetAccountId),
                sourceAccountId != targetAccountId,
              amount >= 0 else { return nil }
        if let sourceAmount = bankAccounts[sourceAccountId]?.amount, sourceAmount - amount >= 0 {
            bankAccounts[sourceAccountId]?.amount -= amount
            bankAccounts[targetAccountId]?.amount += amount
            return bankAccounts[sourceAccountId]?.amount
        }
        return nil
    }
}
