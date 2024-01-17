//
//  ReceiptWriteVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

final class ReceiptWriteVM: ReceiptWriteVMProtocol {
    
    // MARK: - 모델
    private var cellViewModels: [ReceiptWriteCellVM] = [] {
        didSet {
            print("*************************")
            print("*************************")
            print("*************************")
            print(self.cellViewModels.count)
            print("__________________________")
            print("__________________________")
            print("__________________________")
        }
    }
    private var roomDataManager: RoomDataManagerProtocol
    
    
    
    
    var selectedUsers: RoomUserDataDictionary = [:] {
        didSet {
            dump(selectedUsers)
        }
    }
    
    
    
    
    
    var numOfUsers: Int {
        return self.selectedUsers.count
    }
    
    var dutchBtnColor: UIColor {
        return self.numOfUsers == 0
        ? UIColor.normal_white
        : UIColor.deep_Blue
    }
    
    
    

    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol) {
        self.roomDataManager = roomDataManager
        
        
    }
}
    
    
    
    
    
    
    



// MARK: - 셀 설정
    
extension ReceiptWriteVM {
    
    // MARK: - 셀의 뷰모델 만들기
    func makeCellVM(selectedUsers: RoomUserDataDictionary) {
        // 방의 유저들 정보 가져오기
        self.selectedUsers = selectedUsers
        
        self.cellViewModels.removeAll()
        // 유저 정보 보내기
        self.cellViewModels = self.selectedUsers.map { (userID, roomUser) in
            ReceiptWriteCellVM(
                userID: userID,
                roomUsers: roomUser)
        }
    }
    
    // MARK: - 셀 뷰모델 반환
    // cellViewModels 반환
    func cellViewModel(at index: Int) -> ReceiptWriteCellVM {
        return self.cellViewModels[index]
    }
}
