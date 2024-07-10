//
//  MainVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

final class MainVM: MainVMProtocol {
    
    // MARK: - 모델
    var roomDataManager: RoomDataManagerProtocol
    
    
    
    // MARK: - 프로퍼티
    /// 인덱스패스 데이터를 저장해두는 코드
    private var pendingIndexPaths: IndexPathDataManager<Rooms> = IndexPathDataManager()

    
    
    // MARK: - 클로저
    var moveToSettleMoneyRoomClosure: (() -> Void)?
    
    
    // MARK: - 라이프 사이클
    init(roomDataManager: RoomDataManagerProtocol) {
        self.roomDataManager = roomDataManager
    }
    deinit { print("\(#function)-----\(self)") }
}





// MARK: - 콜렉션뷰
extension MainVM {
    /// 방의 개수
    var numberOfRooms: Int {
        return self.roomDataManager.getNumOfRooms
    }
    /// 셀의 뷰모델 반환
    func cellViewModel(at index: Int) -> MainCollectionViewCellVMProtocol? {
        return self.roomDataManager.getRoomsViewModel(index: index)
    }
    /// 아이템이 눌렸을 때, roomDataManager에 선택된(현재) 방 저장
    func itemTapped(index: Int) {
        self.roomDataManager.saveCurrentRooms(index: index) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                    
                case .success():
                    // 클로저 호출
                    self.moveToSettleMoneyRoomClosure?()
                    print("\(#function) ----- success")
                case .failure(_):
                    print("\(#function) ----- error")
                    break
                }
            }
        }
    }
    /// 테이블뷰의 셀을 insert/delete 할 때, [현재 셀]의 개수와 [기존 셀 + 추가하려는 셀]의 개수를 비교
    func validateRowCountChange(
        currentRowCount: Int,
        changedUsersCount: Int
    ) -> Bool {
        return currentRowCount + changedUsersCount == self.numberOfRooms
    }
    
    /// 테이블뷰의 셀을 reload할 때, 해당 셀의 index가 옳은지 확인
    func validateRowExistenceForUpdate(
        indexPaths: [IndexPath],
        totalRows: Int
    ) -> Bool {
        return !indexPaths.contains { $0.row >= totalRows }
    }
}





// MARK: - 노티피케이션 인덱스패스
extension MainVM {
    // 바뀐 인덱스패스 데이터 저장
    func userDataChanged(_ userInfo: [String: Any]) {
        self.pendingIndexPaths.dataChanged(userInfo)
    }
    // 뷰모델에 저장된 변경 사항 반환
    func getPendingUpdates() -> [(key: String, indexPaths: [IndexPath])] {
        return self.pendingIndexPaths.getPendingIndexPaths()
    }
    // 모든 대기 중인 변경 사항 초기화
    func resetPendingUpdates() {
        self.pendingIndexPaths.resetIndexPaths()
    }
}
