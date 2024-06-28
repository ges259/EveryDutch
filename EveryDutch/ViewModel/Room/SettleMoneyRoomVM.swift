//
//  SettlementRoomVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit


final class IndexPathDataManager<T> {
    private var indexPaths: [String: [IndexPath]] = [:]
    private var _error: ErrorEnum?
    
    // 데이터 저장
    func dataChanged(_ userInfo: [String: Any]) {
        
        print("errorData ----- \(#function)")
        dump(userInfo)
        
        for (key, value) in userInfo {
            if let error = value as? ErrorEnum {
                print("errorData ----- \(#function)")
                self._error = error
                // 에러 처리
                print("Error received: \(error)")
            } else if let newValues = value as? [IndexPath] {
                self.indexPaths[key, default: []] = self.mergeIndexPaths(indexPaths[key] ?? [], newValues)
            }
        }
    }
    
    var error: ErrorEnum? {
        return self._error
    }
    
    private func mergeIndexPaths(
        _ existingValues: [IndexPath],
        _ newValues: [IndexPath])
    -> [IndexPath] {
        return Array(Set(existingValues + newValues))
    }
    
    func getPendingIndexPaths() -> [String: [IndexPath]] {
        return self.indexPaths
    }
    
    func resetIndexPaths() {
        self._error = nil
        self.indexPaths.removeAll()
    }
    
    func getPendingSections() -> [String: [Int]] {
        var sections: [String: [Int]] = [:]
        for (key, indexPaths) in self.indexPaths {
            let sectionSet = Set(indexPaths.map { $0.section })
            sections[key] = Array(sectionSet).sorted()
        }
        return sections
    }

}

// HoqSD6z7x0fy1r8AaGG86EgMPRA33
final class SettleMoneyRoomVM: SettleMoneyRoomProtocol {
    
    // MARK: - 인덱스패스 프로퍼티
    private var userDataManager: IndexPathDataManager<User> = IndexPathDataManager()
    private var receiptDataManager: IndexPathDataManager<Receipt> = IndexPathDataManager()
    
    
    
    
    // MARK: - 탑뷰 프로퍼티
    /*
     인원 수에 따라 스택뷰의 maxHeight 크기 바꾸기
     - 하단 크기 : 15
     - 상단 크기 : 35
     - 헤더뷰 크기 : 34
     => 84
     - 인원 수 마다 크기: 40 - 최대 5명 (200)
     --------------- 결론 :  최대 크기 : 134 + 200 ---------------
     */
    /// 탑뷰의 최대 크기
    var maxHeight: CGFloat {
        let usersCount = self.roomDataManager.getNumOfRoomUsers
        // 셀당 40
        let tableHeight: Int = (usersCount * 40)
        
        // + 나머지 크기: (84)
        // + 테이블뷰의 셀 크기: 4명(160) + 반칸 (20)
        let totalHeight: Int = 84 + min(tableHeight, 180)
        return CGFloat(totalHeight)
    }
    /// 탑뷰의 최소 크기
    let minHeight: CGFloat = 50
    /// 탑뷰 토글 (- 탑뷰가 현재 열려있는지 확인하는)
    var isTopViewOpen: Bool = false

    /// 탑뷰 크기 조절 변숫
    var initialHeight: CGFloat = 100
    var currentTranslation: CGPoint = .zero
    var currentVelocity: CGPoint = .zero
    
    
    
    var getMaxAndMinHeight: CGFloat {
        var height = self.initialHeight + self.currentTranslation.y
        // 새 높이가 최대 높이를 넘지 않도록 설정
        height = min(self.maxHeight, height)
        // 새 높이가 최소 높이보다 작아지지 않도록 설정
        height = max(self.minHeight, height)
        // flxjs
        return height
    }
    
    
    
    var navTitle: String? {
        return self.roomDataManager.getCurrentRoomName
    }
    
    /// 뷰모델에 플래그 만들어서, 처음 화면 들어올 때 등 아무때나 업데이트 되지 않도록 설정
    var topViewHeightPlag: Bool = false

    
    
    
    
    
    // MARK: - 모델
    private var roomDataManager: RoomDataManagerProtocol
    private var receiptAPI: ReceiptAPIProtocol
    
    
    
    

    
    // MARK: - 라이프 사이클
    init(receiptAPI: ReceiptAPIProtocol,
         roomDataManager: RoomDataManagerProtocol) {
        self.receiptAPI = receiptAPI
        self.roomDataManager = roomDataManager
        
        // api호출
//        self.roomDataManager.startLoadRoomData()
    }
    deinit {
        print("\(#function)-----\(self)")
        self.roomDataManager.removeRoomsUsersObserver()
    }
    
    // MARK: - API
    func loadMoreReceiptData() {
        self.roomDataManager.loadMoreRoomReceipt()
    }
}










// MARK: - 인덱스패스
extension SettleMoneyRoomVM {
    // 유저 데이터 인덱스패스
    func userDataChanged(_ userInfo: [String: [IndexPath]]) {
        self.userDataManager.dataChanged(userInfo)
    }

    func getPendingUserDataIndexPaths() -> [String: [IndexPath]] {
        return self.userDataManager.getPendingIndexPaths()
    }

    func resetPendingUserDataIndexPaths() {
        self.userDataManager.resetIndexPaths()
    }
}
