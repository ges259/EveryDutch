//
//  MoneyData.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import UIKit

struct CumulativeAmount {
    var userID: String
    var cumulativeAmount: Int
    
    init(userID: String,
         amount: Int) {
        self.userID = userID
        self.cumulativeAmount = amount
    }
}
