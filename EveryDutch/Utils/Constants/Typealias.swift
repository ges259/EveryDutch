//
//  Typealias.swift
//  EveryDutch
//
//  Created by 계은성 on 2/14/24.
//

import Foundation

enum Typealias {
    // ReceiptAPI
    typealias ReceiptArrayCompletion = (Result<[Receipt], ErrorEnum>) -> Void
    
    typealias CreateReceiptCompletion = (Result<String, ErrorEnum>) -> Void
    
    
    typealias IndexPathsCompletion = (Result<[IndexPath], ErrorEnum>) -> Void
    
    
    
    // UserAPI
    typealias UserCompletion = (Result<User, ErrorEnum>) -> Void
    
    // RoomsAPI
    typealias RoomCompletion = (Result<Rooms, ErrorEnum>) -> Void
    typealias RoomsIDCompletion = (Result<[Rooms], ErrorEnum>) -> Void
    typealias RoomUsersCompletion = (Result<[String: User], ErrorEnum>) -> Void
//    typealias RoomMoneyDataCompletion = (Result<CumulativeAmountDictionary, ErrorEnum>) -> Void
//    typealias PaybackCompletion = (Result<Payback, ErrorEnum>) -> Void
    
    
    
    // AuthAPIProtocol
    typealias VoidCompletion = (Result<Void, ErrorEnum>) -> Void
    
    
    // ReceiptWriteVM
    typealias ReceiptCompletion = (Result<Receipt, ErrorEnum>) -> Void
}



// RoomDataManager
typealias RoomUserDataDict = [String : User]
//typealias CumulativeAmountDictionary = [String : CumulativeAmount]

// PeopleSelectionPanVM
typealias UserDataTuple = (key: String, value: User)
typealias floatingType = (show: Bool, alpha: CGFloat)



typealias ReceiptCellTypeTuple = (type: ReceiptCellEnum, detail: String?)
typealias ReceiptTypeTuple = (type: ReceiptWriteCellVMProtocol, detail: String?)
typealias ProfileTypeCell = (type: ProfileType, detail: String?)
typealias EditCellTypeTuple = (type: any EditCellType, detail: String?)


typealias ReceiptTuple = (receiptID: String, receipt: Receipt)




typealias ReceiptWriteCellTuple = (type: ReceiptWriteCellType?, viewModel: ReceiptWriteCellVMProtocol)


typealias UserDecoTuple = (user: User, deco: Decoration?)
