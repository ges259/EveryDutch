//
//  UserProfileVM.swift
//  EveryDutch
//
//  Created by 계은성 on 6/12/24.
//

import Foundation

final class UserProfileVM: UserProfileVMProtocol {

    
    
    let roomDataManager: RoomDataManagerProtocol
    
    var fetchSuccessClosure: (([IndexPath]) -> Void)?
    var errorClosure: ((ErrorEnum) -> Void)?
    
    
    
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol)
    {
        self.roomDataManager = roomDataManager
        
    }
    deinit { self.roomDataManager.resetUserReceipt() }
    var btnStvInsets: CGFloat {
        return self.isRoomManager
        ? 30 + 20
        : 80 + 20
    }
    
    
    
    
    // MARK: - 유저 데이터
    lazy var isRoomManager: Bool = {
        return self.roomDataManager.checkIsRoomManager
    }()
    var getUserDecoTuple: UserDecoTuple? {
        return self.roomDataManager.getCurrentUserData
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 영수증 로드
    func loadUserReceipt() {
        print(#function)
        self.roomDataManager.fetchUserReceipt { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let indexPaths):
                self.fetchSuccessClosure?(indexPaths)
                
            case .failure(let error):
                self.errorClosure?(error)
            }
        }
    }
    
    
    
    
    
    var getUserReceiptLoadSuccess: Bool {
        self.roomDataManager.getUserReceiptLoadSuccess
    }
        
        
    
    // MARK: - 영수증 테이블뷰
    /// 영수증 개수
    var numberOfReceipt: Int {
        return self.roomDataManager.getNumOfUserReceipts
    }
    /// 영수증 셀의 뷰모델 반환
    func cellViewModel(at index: Int) -> ReceiptTableViewCellVMProtocol {
        return self.roomDataManager.getUserReceiptViewModel(index: index)
    }
    
    func getReceipt(at index: Int) -> Receipt {
        return self.roomDataManager.getReceipt(at: index)
    }
}
