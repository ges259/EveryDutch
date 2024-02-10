//
//  CreateReceipt.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation

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
    static let shared: ReceiptAPI = ReceiptAPI()
    private init() {}
    
    typealias ReceiptCompletion = (Result<[Receipt], ErrorEnum>) -> Void
    
}


extension ReceiptAPI {
    
    func dd(roomData: [String],
            context: String?,
            date: Int,
            time: String,
            price: Int,
            payer: String,
            paymentDetails: [String: Int]) {
        
        /*
         paymentMethod: Int,
         type: Int
         */
    }
    
    func createReceipt(roomData: [String],
                       context: String?,
                       date: Int,
                       time: String,
                       price: Int,
                       payer: String,
                       paymentDetails: [String: Int]) {
        // version_ID
        // room_ID
        
//         context: String
//         date: Int
//         time: String
//         price: Int
//         payer: String
//         paymentDetails: [:]
//         paymentMethod
//         type: Int
        
        // 현재 시간 설정
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let dictionary: [String: Any] = [
//            "receiptID": "receiptID",
            "type": 0,
            "context": "맥도날드",
            "date": creationDate,
            "time": creationDate,
            "price": "50000",
            "payer": "eeeeee",
            "paymentMethod": 1,
            "paymentDetails": self.toDictionary()
        ]
        
        
        RECEIPT_REF
            .child("version_ID_1")
            .child("receipt_ID_3")
            .setValue(dictionary) { error, ref in
                
                
            if let error = error {
                print("Data could not be saved: \(error.localizedDescription)")
            } else {
                print("Data saved successfully!")
            }
        }
        
        
        
        
    }
    
    
    private func toDictionary() -> [String: [String: Any]] {
        return ["qqqqqq" : [
            "pay": "25000",
            "done": true]
        ]
    }
    
}
