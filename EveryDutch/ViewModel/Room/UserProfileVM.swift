//
//  UserProfileVM.swift
//  EveryDutch
//
//  Created by 계은성 on 6/12/24.
//

import Foundation

final class UserProfileVM: UserProfileVMProtocol {

    
    let userDecoTuple: UserDecoTuple?
    let roomDataManager: RoomDataManagerProtocol
    
    
    
    // MARK: - 라이프사이클
    init(roomDataManager: RoomDataManagerProtocol)
    {
        self.roomDataManager = roomDataManager
        self.userDecoTuple = self.roomDataManager.getCurrentUserData
        
    }
    
    lazy var isRoomManager: Bool = {
        return self.roomDataManager.checkIsRoomManager
    }()
    
    
    var btnStvInsets: CGFloat {
        return self.isRoomManager
        ? 30 + 20
        : 80 + 20
    }
    
    var getUserDecoTuple: UserDecoTuple? {
        return self.userDecoTuple
    }
    
    var fetchSuccessClosure: (([IndexPath]) -> Void)?
    var errorClosure: ((ErrorEnum) -> Void)?
    
    func fetchInitialUserReceipt() {
        self.loadUserReceipt(fetchFunction: self.roomDataManager.loadUserReceipt)
    }

    func loadMoreUserReceipt() {
        self.loadUserReceipt(fetchFunction: self.roomDataManager.loadUserRoomReceipt)
    }
    
    private func loadUserReceipt(
        fetchFunction: (@escaping Typealias.IndexPathsCompletion) -> Void)
    {
        fetchFunction { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let indexPaths):
                self.fetchSuccessClosure?(indexPaths)
            case .failure(let error):
                self.errorClosure?(error)
            }
        }
    }
    
    
    
    
    // MARK: - 영수증 테이블뷰
    /// 영수증 개수
    var numberOfReceipt: Int {
        return self.roomDataManager.getNumOfReceipts
    }
    /// 영수증 셀의 뷰모델 반환
    func cellViewModel(at index: Int) -> ReceiptTableViewCellVMProtocol {
        return self.roomDataManager.getReceiptViewModel(index: index)
    }
    
    func getReceipt(at index: Int) -> Receipt {
        return self.roomDataManager.getReceipt(at: index)
    }
}
