//
//  TableHeaderEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2/23/24.
//

import UIKit

enum TableHeaderEnum {
    case receiptWriteVC
    case profileVC
    
    var getBackgroundColor: UIColor {
        switch self {
        case .receiptWriteVC:   return .normal_white
        case .profileVC:        return .medium_Blue
        }
    }
}
