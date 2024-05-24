//
//  Receipt.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit

struct Receipt {
    var type: Int
    var context: String
    var date: String
    var time: String
    var price: Int
    var payer: String
    var paymentMethod: Int
    var paymentDetails: [PaymentDetail]
    
    
    var payerName: String = "???"

    // MARK: - init
    init(dictionary: [String: Any]) {
        self.type = dictionary[DatabaseConstants.type] as? Int ?? 0
        self.context = dictionary[DatabaseConstants.context] as? String ?? ""
        self.price = dictionary[DatabaseConstants.price] as? Int ?? 0
        self.payer = dictionary[DatabaseConstants.payer] as? String ?? ""
        self.paymentMethod = dictionary[DatabaseConstants.payment_method] as? Int ?? 0
        
        // 날짜 및 시간 설정을 별도의 함수로 추출
        let timeInteger = dictionary[DatabaseConstants.date] as? Int ?? 0
        let date = Date(timeIntervalSince1970: TimeInterval(timeInteger))
        
        self.date = Date.returnYearString(date: date)
        
        self.time = dictionary[DatabaseConstants.time] as? String ?? ""

        // paymentDetails 설정을 별도의 함수로 추출
        self.paymentDetails = Receipt.unpackPaymentDetails(from: dictionary)
    }
    
    
    // MARK: - PaymentDetails 설정
    private static func unpackPaymentDetails(
        from dictionary: [String: Any])
    -> [PaymentDetail] {
        guard let detailsDict = dictionary[DatabaseConstants.payment_details] as? [String: [String: Any]] else {
            return []
        }
        
        return detailsDict.map { userID, detail in
            let pay = detail[DatabaseConstants.pay] as? Int ?? 0
            let done = detail[DatabaseConstants.done] as? Bool ?? false
            return PaymentDetail(userID: userID, pay: pay, done: done)
        }
    }
    
    // MARK: - payerName 저장
    mutating func updatePayerName(with user: User) {
        self.payerName = user.userName == ""
        ? "???"
        : user.userName
    }
}
