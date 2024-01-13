//
//  ReceiptWriteVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

final class ReceiptWriteVM: ReceiptWirteVMProtocol { 
    
    
    private var cellViewModels: [ReceiptWriteCellVM] = []
    
    
    
    
    var roomDataManager: RoomDataManager
    
    var roomUsers: [RoomUsers] = []
    
    var numOfUsers: Int {
        return self.roomUsers.count
    }
    
    
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManager) {
        self.roomDataManager = roomDataManager
        
        self.makeCellVM()
    }
    
    
    func makeCellVM() {
        // 방의 유저들 정보 가져오기
        self.roomUsers = self.roomDataManager.getRoomUsers
        
        // 유저 정보 보내기
        self.cellViewModels = self.roomUsers.map { user in
            ReceiptWriteCellVM(roomUsers: user)
        }
    }
    
    
    
    
    
    // MARK: - 셀 뷰모델 반환
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> ReceiptWriteCellVM {
        return self.cellViewModels[index]
    }
    
}
