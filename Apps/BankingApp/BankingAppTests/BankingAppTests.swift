//
//  BankingAppTests.swift
//  BankingAppTests
//
//  Created by Vali Zairov on 9/5/25.
//

import XCTest
@testable import BankingApp

final class BankingImplementationTests: XCTestCase {
    var banking: BankingProtocol!
    
    override func setUp() {
        super.setUp()
        banking = BankingImplementation()
    }
    
    override func tearDown() {
        banking = nil
        super.tearDown()
    }
    
    // MARK: - Account Creation
    
    func testCreateAccountSuccessfully() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
    }
    
    func testCreateAccountFailsIfAlreadyExists() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertFalse(banking.createAccount("acc1", 2))
    }
    
    func testCreateMultipleUniqueAccounts() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertTrue(banking.createAccount("acc2", 2))
        XCTAssertTrue(banking.createAccount("acc3", 3))
    }
    
    // MARK: - Deposits
    
    func testDepositToNonexistentAccountReturnsNil() {
        XCTAssertNil(banking.deposit(to: "unknown", 100))
    }
    
    func testDepositToExistingAccountUpdatesBalance() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertEqual(banking.deposit(to: "acc1", 100), 100)
    }
    
    func testMultipleDepositsAccumulate() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertEqual(banking.deposit(to: "acc1", 100), 100)
        XCTAssertEqual(banking.deposit(to: "acc1", 50), 150)
        XCTAssertEqual(banking.deposit(to: "acc1", 25), 175)
    }
    
    func testDepositZeroAmount() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertEqual(banking.deposit(to: "acc1", 0), 0)
    }
    
    func testDepositNegativeAmountDoesNotChangeBalance() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertNil(banking.deposit(to: "acc1", -50))
    }
    
    // MARK: - Transfers
    
    func testTransferFailsIfSourceAccountDoesNotExist() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertNil(banking.transfer(10, "unknown", "acc1", 100))
    }
    
    func testTransferFailsIfTargetAccountDoesNotExist() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertNil(banking.transfer(10, "acc1", "unknown", 100))
    }
    
    func testTransferFailsIfInsufficientFunds() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertTrue(banking.createAccount("acc2", 2))
        XCTAssertEqual(banking.deposit(to: "acc1", 50), 50)
        
        XCTAssertNil(banking.transfer(10, "acc1", "acc2", 100))
    }
    
    func testTransferSuccessfulUpdatesBalances() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertTrue(banking.createAccount("acc2", 2))
        XCTAssertEqual(banking.deposit(to: "acc1", 200), 200)
        
        XCTAssertEqual(banking.transfer(10, "acc1", "acc2", 150), 50) // source balance after transfer
        XCTAssertEqual(banking.deposit(to: "acc2", 0), 150) // check target balance
    }
    
    func testTransferZeroAmountDoesNothing() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertTrue(banking.createAccount("acc2", 2))
        XCTAssertEqual(banking.deposit(to: "acc1", 100), 100)
        
        XCTAssertEqual(banking.transfer(10, "acc1", "acc2", 0), 100)
        XCTAssertEqual(banking.deposit(to: "acc2", 0), 0)
    }
    
    func testTransferNegativeAmountFails() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertTrue(banking.createAccount("acc2", 2))
        XCTAssertEqual(banking.deposit(to: "acc1", 100), 100)
        
        XCTAssertNil(banking.transfer(10, "acc1", "acc2", -50))
    }
    
    // MARK: - Edge Cases
    
    func testLargeDeposit() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertEqual(banking.deposit(to: "acc1", Int.max), Int.max)
    }
    
    func testLargeTransfer() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertTrue(banking.createAccount("acc2", 2))
        XCTAssertEqual(banking.deposit(to: "acc1", Int.max), Int.max)
        
        XCTAssertEqual(banking.transfer(10, "acc1", "acc2", Int.max), 0)
        XCTAssertEqual(banking.deposit(to: "acc2", 0), Int.max)
    }
    
    func testMultipleTransfersBetweenAccounts() {
        XCTAssertTrue(banking.createAccount("acc1", 1))
        XCTAssertTrue(banking.createAccount("acc2", 2))
        XCTAssertEqual(banking.deposit(to: "acc1", 500), 500)
        
        XCTAssertEqual(banking.transfer(10, "acc1", "acc2", 100), 400)
        XCTAssertEqual(banking.transfer(11, "acc1", "acc2", 200), 200)
        XCTAssertEqual(banking.transfer(12, "acc1", "acc2", 200), 0)
        
        XCTAssertEqual(banking.deposit(to: "acc2", 0), 500)
    }
}

