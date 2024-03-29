//
//  ReceiptWriteTableDelegate.swift
//  EveryDutch
//
//  Created by 계은성 on 1/18/24.
//

import UIKit

protocol ReceiptWriteTableDelegate: AnyObject {
    func rightBtnTapped(user: RoomUserDataDict?)
    func setprice(userID: String, price: Int?)
}
