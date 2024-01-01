//
//  SettlementRoomCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit


final class SettleMoneyRoomCoordinator: SettleMoneyRoomCoordinating {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********SettleMoneyRoomCoordinator**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    
    var nav: UINavigationController
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        // SettlementRoomVM 뷰모델 생성
        let settlementRoomVM = SettleMoneyRoomVM()
        // PlusViewController 인스턴스 생성
        let settlementRoomVC = SettleMoneyRoomVC(viewModel: settlementRoomVM,
                                                coordinator: self)
        // push를 통해 화면 이동
        self.nav.pushViewController(settlementRoomVC, animated: true)
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
    
    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    
    deinit {
        print("deinit ----- \(#function)-----\(self)")
    }
}
