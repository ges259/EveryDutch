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

    init(dictionary: [String: Any]) {
        self.type = dictionary[DatabaseConstants.type] as? Int ?? 0
        self.context = dictionary[DatabaseConstants.context] as? String ?? ""
        self.price = dictionary[DatabaseConstants.price] as? Int ?? 0
        self.payer = dictionary[DatabaseConstants.payer] as? String ?? ""
        self.paymentMethod = dictionary[DatabaseConstants.payment_method] as? Int ?? 0
        
        // 날짜 및 시간 설정을 별도의 함수로 추출
        let dateArray = Receipt.unpackDateAndTime(from: dictionary)
        self.date = dateArray[0]
        self.time = dateArray[1]

        // paymentDetails 설정을 별도의 함수로 추출
        self.paymentDetails = Receipt.unpackPaymentDetails(from: dictionary)
    }
    
    // MARK: - 시간 및 날짜 설정
    private static func unpackDateAndTime(
        from dictionary: [String: Any])
    -> [String] {
        if let timestamp = dictionary[DatabaseConstants.date] as? Int {
            let dateComponents = Date.IntegerToString(timestamp)
            
            return dateComponents
        }
        return []
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
}
// 지불 세부 정보를 위한 내부 구조체
struct PaymentDetail: Codable {
    var userID: String
    var pay: Int
    var done: Bool
    var userName: String = ""
    var userImg: String = ""
}
