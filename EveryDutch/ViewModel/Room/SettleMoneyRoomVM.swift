//
//  SettlementRoomVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit

final class SettleMoneyRoomVM: SettleMoneyRoomProtocol {
    
    private var cellViewModels: [SettlementTableViewCellVM] = []
    var roomData: Rooms
    
    
    
    var receiptChangedClosure: (() -> Void)?
    var userChangedClosure: (([RoomUsers]) -> Void)?
    
    
    
    var receipts: [Receipt] = [] {
        didSet {
            self.receiptChangedClosure?()
        }
    }
    var roomUser: [RoomUsers] = [] {
        didSet {
            self.userChangedClosure?(self.roomUser)
        }
    }
    
    
    
    
    var numberOfReceipt: Int {
        return self.cellViewModels.count
    }
    
    init(roomData: Rooms) {
        self.roomData = roomData
        
        
        ReceiptAPI.shared.readReceipt { result in
            switch result {
            case .success(let receipts):
                
                
                self.cellViewModels = receipts.map({ receipt in
                    SettlementTableViewCellVM(receiptData: receipt)
                })
                self.receipts = receipts
                
                
                break
                // MARK: - Fix
            case .failure(_): break
            }
        }
        
        RoomsAPI.shared.readRoomUsers(
            roomID: roomData.roomID) { result in
                switch result {
                case .success(let users):
                    self.roomUser = users
                    break
                    // MARK: - Fix
                case .failure(_): break
                }
            }
    }
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> SettlementTableViewCellVM {
        return self.cellViewModels[index]
    }
    
    
    deinit {
        print("------------------------------------------------------------")
    }
}
