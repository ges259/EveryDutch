//
//  CreateReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation
import FirebaseDatabase

// Create
    // Receipt에 데이터 저장 ----- (Receipt)
    // 개인적으로 데이터 저장 ----- (User_Receipt)

class ReceiptAPI: ReceiptAPIProtocol, CrashlyticsLoggable {
    static let shared: ReceiptAPIProtocol = ReceiptAPI()
    private init() {}
    
    
    func resetReceiptLastKey() {
        self.roomLastKey = nil
        self.observing = false
        self.roomLastDate = nil
        self.existingReceiptIDs = []
    }
    func resetUserReceiptKey() {
        self.userLastKey = nil
    }
    var roomLastDate: Double?
    
    var existingReceiptIDs: Set<String> = []
    
    var roomLastKey: String?
    var userLastKey: String?
    var observing = false
}


    // ************************************
    // - 비동기 작업 순서
    // 1. 누적 금액 업데이트
    // 2. 페이백 업데이트
    // 3. 영수증 만들기
    // 4. 유저의 영수증 저장
    // ************************************
extension ReceiptAPI {
    
    // MARK: - 영수증 만들기
    func createReceipt(
        versionID: String,
        dictionary: [String: Any?]
    ) async throws -> String {
        let path = RECEIPT_REF
            .child(versionID)
            .childByAutoId()
        let filteredDictionary = dictionary.compactMapValues { $0 }
        
        return try await withCheckedThrowingContinuation { continuation in
            path.setValue(filteredDictionary) { error, ref in
                if let error = error {
                    // 에러 로깅
                    let info = ["versionID": versionID,
                                "dictionaryKeys": filteredDictionary.keys.joined(separator: ", ")]
                    self.logError(error, 
                                  withAdditionalInfo: info,
                                  functionName: #function)
                    continuation.resume(throwing: ErrorEnum.readError)
                } else if let key = ref.key {
                    // 성공
                    continuation.resume(returning: key)
                } else {
                    // 알 수 없는 에러
                    continuation.resume(throwing: ErrorEnum.unknownError)
                }
            }
        }
    }
    
    // MARK: - 유저의 영수증 저장
    func saveReceiptForUsers(
        versionID: String,
        receiptID: String,
        dict: [String: Bool]
    ) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            dict.forEach { userID, value in
                group.addTask {
                    let path = USER_RECEIPTS_REF
                        .child(versionID)
                        .child(userID)
                    
                    try await self.updateChildValues(
                        path: path,
                        values: [receiptID: value]
                    )
                }
            }
            
            try await group.waitForAll()
        }
    }
    
    private func updateChildValues(
        path: DatabaseReference,
        values: [String: Any]
    ) async throws {
        try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            path.updateChildValues(values) { error, _ in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
