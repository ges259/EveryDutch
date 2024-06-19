//
//  ReceiptAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation
protocol ReceiptAPIProtocol {
    
    func resetReceiptLastKey()
    
    func createReceipt(versionID: String,
                       dictionary: [String: Any?]) async throws -> String
    
    func saveReceiptForUsers(
        versionID: String,
        receiptID: String,
        users: [String]) async throws
    
    // MARK: - 누적 금액 업데이트
    func updateCumulativeMoney(versionID: String, moneyDict: [String: Int]) async throws
    
    
    // MARK: - 페이백 업데이트
    func updatePayback(versionID: String, payerID: String, moneyDict: [String: Int]) async throws
    
    
    
    
    func readRoomReceipts(
        versionID: String,
        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void)
    func loadMoreRoomReceipts(
        versionID: String,
        completion: @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void)
    
    
    
//    func observeReceipt(
//        versionID: String,
//        completion: @escaping (Result<DataChangeEvent<[ReceiptTuple]>, ErrorEnum>) -> Void
//    )
    
    
    
    
    
    
    func resetUserReceiptKey()
    func loadInitialUserReceipts(
        userID: String,
        versionID: String,
        completion: @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void
    )
    func loadMoreUserReceipts(
        userID: String,
        versionID: String,
        completion: @escaping (Result<[ReceiptTuple], ErrorEnum>) -> Void
    )
    
    
      
}
