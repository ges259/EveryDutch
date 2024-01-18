//
//  ReceiptWriteCoordinating.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/01.
//

import Foundation

protocol ReceiptWriteCoordProtocol: Coordinator {
    func peopleSelectionPanScreen(users: RoomUserDataDictionary?,
                                  peopleSelectionEnum: PeopleSeelctionEnum?)
    func checkReceiptPanScreen()
}
