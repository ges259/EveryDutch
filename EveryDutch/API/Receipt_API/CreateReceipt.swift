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

// Read
    // Receipt에서 데이터 가져오기 ----- (Receipt)

// Update
    // type 변경 ----- (Receipt)
    // payment_details[done: Bool] 변경 ----- (Receipt)

// Delete
    // 영수증 삭제
        // User_Receipt에서 삭제
        // Receipt에서 삭제
struct ReceiptAPI: ReceiptAPIProtocol {
    static let shared: ReceiptAPIProtocol = ReceiptAPI()
    private init() {}
    
    
    typealias ReceiptCompletion = (Result<[Receipt], ErrorEnum>) -> Void
}


extension ReceiptAPI {
    
    
    // MARK: - 영수증 만들기
    func createReceipt(versionID: String,
                       dictionary: [String: Any?],
                       users: [String],
                       completion: @escaping () -> Void) {
        
        let dict = dictionary.compactMapValues{ $0 }
        
        RECEIPT_REF
            .child(versionID)
            .childByAutoId()
            .setValue(dict) { error, ref in
                
            if let error = error {
                print("Data could not be saved: \(error.localizedDescription)")
            } else {
                print("Data saved successfully!")
                
                
                if let receiptKey = ref.key {
                    self.saveReceiptForUsers(
                        receiptID: receiptKey,
                        users: users) {
                            completion()
                        }
                }
            }
        }
    }
    // -NqXlbrhlMCBqQIyORD1
    
    private func saveReceiptForUsers(receiptID: String, 
                                     users: [String],
                                     completion: @escaping () -> Void) {
        let saveGroup = DispatchGroup()
        
        for userID in users {
            
            saveGroup.enter()
            
            USER_RECEIPTS_REF
                .child(userID)
                .updateChildValues([receiptID: true]) { error, _ in
                    
                if let error = error {
                    print("Error saving user receipt mapping: \(error.localizedDescription)")
                }
                    
                saveGroup.leave()
            }
        }
        
        saveGroup.notify(queue: .main) {
            print("All user receipt mappings saved successfully!")
            completion()
        }
    }
    
    
    
    
    // MARK: - 누적 금액 업데이트
    // 유저의 금액 정보를 업데이트하는 함수를 정의합니다.
    func updateCumulativeMoney(versionID: String,
                           usersMoneyDict: [String: Int],
                           completion: @escaping (Result<(), ErrorEnum>) -> Void) {
        
        let group = DispatchGroup()
        
        var hasErrorOccurred = false // 에러 발생 여부를 추적합니다.
        
        for (userId, amountToAdd) in usersMoneyDict {
            group.enter()
            
            Cumulative_AMOUNT_REF
                .child(versionID)
                .child(userId)
                .runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
                    
                var value = currentData.value as? Int ?? 0
                value += amountToAdd
                currentData.value = value
                
                return TransactionResult.success(withValue: currentData)
                    
            }) { (error, committed, snapshot) in
                if let _ = error {
                    hasErrorOccurred = true // 에러가 발생했음을 표시합니다.
                    completion(.failure(.readError)) // 에러를 반환합니다.
                    return
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if !hasErrorOccurred {
                completion(.success(()))
            }
        }
    }
    
    
    // MARK: - 페이백 업데이트
    func updatePayback(versionID: String,
                       payerID: String,
                       usersMoneyDict: [String: Int],
                       completion: @escaping (Result<(), ErrorEnum>) -> Void) {

        // usersMoneyDict에 있는 각 사용자 ID에 대해 트랜잭션을 실행합니다.
        for (userID, amount) in usersMoneyDict {
            
            PAYBACK_REF
                .child(versionID)
                .child(payerID)
                .child(userID)
                .runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
                // 현재 저장된 금액을 가져옵니다. 값이 없으면 0으로 시작합니다.
                var currentAmount = currentData.value as? Int ?? 0
                
                // 추가할 금액을 더합니다.
                currentAmount += amount
                
                // 수정된 금액을 다시 저장합니다.
                currentData.value = currentAmount
                
                // 트랜잭션의 성공 결과를 반환합니다.
                return TransactionResult.success(withValue: currentData)
                    
            }) { error, committed, snapshot in
                if let _ = error {
                    // 에러가 발생한 경우, 에러를 반환합니다.
                    completion(.failure(.readError))
                    return
                }
            }
        }
        
        // 모든 트랜잭션이 성공적으로 완료되면, 완료 핸들러를 호출합니다.
        completion(.success(()))
    }
}
