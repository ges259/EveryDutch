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
    /// 플로팅 버튼의 현재 상태
    private var isFloatingShow: Bool = false
    /// 인덱스패스 데이터를 저장해두는 코드
    private var pendingIndexPaths: IndexPathDataManager<Rooms> = IndexPathDataManager()

    
    
    // MARK: - 클로저
    var onFloatingShowChangedClosure: ((floatingType) -> Void)?
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
    
    // MARK: - 노티피케이션 인덱스패스
    // 바뀐 인덱스패스 데이터 저장
    func userDataChanged(_ userInfo: [String: Any]) {
        self.pendingIndexPaths.dataChanged(userInfo)
    }
    // 뷰모델에 저장된 변경 사항 반환
    func getPendingUpdates() -> [String: [IndexPath]] {
        return self.pendingIndexPaths.getPendingIndexPaths()
    }
    // 모든 대기 중인 변경 사항 초기화
    func resetPendingUpdates() {
        self.pendingIndexPaths.resetIndexPaths()
    }
}
    
    
    
    

    
    
    
    
    
// MARK: - 플로팅 버튼
extension MainVM {
    /// 플로팅 버튼 Alpha
    private var getBtnAlpha: CGFloat {
        return self.isFloatingShow ? 1 : 0
    }
    
    /// 플로팅 버튼 상태 여부
    var getIsFloatingStatus: Bool {
        return self.isFloatingShow
    }
    
    /// 플로팅 버튼 위치 변경
    var getBtnTransform: CGAffineTransform {
        return self.isFloatingShow
        ? CGAffineTransform.identity
        : CGAffineTransform(translationX: 0, y: 80)
    }
    
    /// 메뉴 버튼 회전
    var getSpinRotation: CGAffineTransform {
        return self.isFloatingShow
        ? CGAffineTransform(rotationAngle: .pi - (.pi / 4))
        : CGAffineTransform.identity
    }
    
    /// 메뉴 버튼 이미지
    var getMenuBtnImg: UIImage? {
        return self.isFloatingShow
        ? UIImage.plus_Img
        : UIImage.menu_Img
    }
    
    /// 플로팅 버튼 토글
    func toggleFloatingShow() {
        self.isFloatingShow.toggle()
        // 클로저 실행
        self.floatinBtnClosure()
    }
    
    /// 플로팅 클로저 실행
    private func floatinBtnClosure() {
        let show: Bool = self.getIsFloatingStatus
        let alpha: CGFloat = self.getBtnAlpha
        
        self.onFloatingShowChangedClosure?((show, alpha))
    }
}
