//
//  MoneyData.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit

struct MoneyData {
    var userID: String
    var cumulativeAmount: Int
    var payback: [Payback] = []
    
    init(userID: String,
         dictionary: [String: Any]) {
        self.userID = userID
        
        self.cumulativeAmount = dictionary[DatabaseEnum.cumulative_Amount] as? Int ?? 0
        self.payback = self.unpachPaybck(dictionary: dictionary)
    }
    
    
    private func unpachPaybck(
        dictionary: [String: Any])
    -> [Payback] {
        
        guard let payback = dictionary[DatabaseEnum.payback] as? [String: Int] else { return [] }
        
        return payback.map { (userID, pay) in
            Payback(userID: userID,
                    pay: pay)
        }
    }
}

struct Payback {
    var userID: String
    var pay: Int
}
