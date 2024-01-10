//
//  SettlementRoomCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit


final class SettleMoneyRoomCoordinator: SettleMoneyRoomCoordProtocol {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********SettleMoneyRoomCoordinator**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    
    var nav: UINavigationController
    
    var room: Rooms
    
    // 의존성 주입
    init(nav: UINavigationController,
         room: Rooms) {
        self.nav = nav
        self.room = room
    }
    
    func start() {
        // SettlementRoomVM 뷰모델 생성
        let settlementRoomVM = SettleMoneyRoomVM(roomData: self.room)
        // PlusViewController 인스턴스 생성
        let settlementRoomVC = SettleMoneyRoomVC(
            viewModel: settlementRoomVM,
            coordinator: self)
        // push를 통해 화면 이동
        self.nav.pushViewController(settlementRoomVC, animated: true)
        // 네비게이션 컨트롤러 참조 저장
    }
    
    func RoomSettingScreen() {
        let roomSettingCoordinator = RoomSettingCoordinator(nav: self.nav)
        self.childCoordinators.append(roomSettingCoordinator)
            roomSettingCoordinator.parentCoordinator = self
            roomSettingCoordinator.start()
    }
    func receiptWriteScreen() {
        let receiptWriteCoordinator = ReceiptWriteCoordinator(nav: self.nav)
        self.childCoordinators.append(receiptWriteCoordinator)
            receiptWriteCoordinator.parentCoordinator = self
            receiptWriteCoordinator.start()
    }
    func ReceiptScreen(receipt: Receipt,
                       users: [RoomUsers]) {
        // PeopleSelectionPanCoordinator 생성
        let receiptScreenPanCoordinator = ReceiptScreenPanCoordinator(
            nav: self.nav, 
            receipt: receipt,
            users: users)
        self.childCoordinators.append(receiptScreenPanCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        receiptScreenPanCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
        receiptScreenPanCoordinator.start()
    }
    
    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    
    deinit {
        print("deinit ----- \(#function)-----\(self)")
    }
}
