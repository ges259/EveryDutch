//
//  ReceiptWriteCoordinating.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/01.
//

import Foundation

protocol ReceiptWriteCoordProtocol: Coordinator {
    func peopleSelectionPanScreen(users: RoomUserDataDict?,
                                  peopleSelectionEnum: PeopleSeelctionEnum?)
    func checkReceiptPanScreen(_ validationDict: [String: Any?])
    func successMakeReceipt(receipt: Receipt)
}
