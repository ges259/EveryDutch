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

    // 지불 세부 정보를 위한 내부 구조체
    struct PaymentDetail: Codable {
        var userID: String
        var pay: Int
        var done: Bool
    }
    
    
    init(dictionary: [String: Any]) {
        self.type = dictionary[DatabaseEnum.type] as? Int ?? 0
        self.context = dictionary[DatabaseEnum.context] as? String ?? ""
        let date = dictionary[DatabaseEnum.date] as? Int ?? 0
//        self.date = dictionary[DatabaseEnum.date] as? String ?? ""
        self.date = String(date)
//        self.time = dictionary[DatabaseEnum.time] as? String ?? ""
        self.time = String(date)
        self.price = dictionary[DatabaseEnum.price] as? Int ?? 0
        self.payer = dictionary[DatabaseEnum.payer] as? String ?? ""
        self.paymentMethod = dictionary[DatabaseEnum.payment_method] as? Int ?? 0
        
        
        
        if let detailsDict = dictionary[DatabaseEnum.paymenet_details] as? [String: [String: Any]] {
            var detailsArray = [PaymentDetail]()
            
            for (userID, detail) in detailsDict {
                // 하나씩 꺼내기
                // 키 값
                let userID = userID
                // 벨류 값
                let pay = detail[DatabaseEnum.pay] as? Int ?? 0
                let done = detail[DatabaseEnum.done] as? Bool ?? false
                
                // 저장
                let detail = PaymentDetail(userID: userID,
                                            pay: pay,
                                            done: done)
                detailsArray.append(detail)
            }
            self.paymentDetails = detailsArray

        } else {
            self.paymentDetails = []
        }
    }
}
