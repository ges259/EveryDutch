//
//  Typealias.swift
//  EveryDutch
//
//  Created by 계은성 on 2/14/24.
//

import Foundation

enum Typealias {
    // ReceiptAPI
    typealias ReceiptCompletion = (Result<[Receipt], ErrorEnum>) -> Void
    
    // UserAPI
    typealias UserCompletion = (Result<User, ErrorEnum>) -> Void
    
    // RoomsAPI
    typealias RoomsIDCompletion = (Result<[Rooms], ErrorEnum>) -> Void
    typealias RoomUsersCompletion = (Result<[String: RoomUsers], ErrorEnum>) -> Void
    typealias RoomMoneyDataCompletion = (Result<CumulativeAmountDictionary, ErrorEnum>) -> Void
    typealias PaybackCompletion = (Result<Payback, ErrorEnum>) -> Void
    
    
    
    // AuthAPIProtocol
    typealias AnoonymouslyCompletion = (Result<Void, ErrorEnum>) -> Void

}

// RoomDataManager
typealias RoomUserDataDictionary = [String : RoomUsers]
typealias CumulativeAmountDictionary = [String : CumulativeAmount]

// PeopleSelectionPanVM
typealias UserDataTuple = (key: String, value: RoomUsers)
typealias floatingType = (show: Bool, alpha: CGFloat)
