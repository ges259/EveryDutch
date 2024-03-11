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
    
    
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        // SettlementRoomVM 뷰모델 생성
        let settlementRoomVM = SettleMoneyRoomVM(
            receiptAPI: ReceiptAPI.shared,
            roomDataManager: RoomDataManager.shared)
        // PlusViewController 인스턴스 생성
        let settlementRoomVC = SettleMoneyRoomVC(
            viewModel: settlementRoomVM,
            coordinator: self)
        // push를 통해 화면 이동
        self.nav.pushViewController(settlementRoomVC, animated: true)
        // 네비게이션 컨트롤러 참조 저장
    }
    
    func RoomSettingScreen() {
        let roomSettingCoordinator = RoomSettingCoordinator(
            nav: self.nav)
        self.childCoordinators.append(roomSettingCoordinator)
        roomSettingCoordinator.parentCoordinator = self
        roomSettingCoordinator.start()
    }
    func receiptWriteScreen() {
        let receiptWriteCoordinator = ReceiptWriteCoordinator(
            nav: self.nav)
        self.childCoordinators.append(receiptWriteCoordinator)
        receiptWriteCoordinator.delegate = self
        receiptWriteCoordinator.parentCoordinator = self
        receiptWriteCoordinator.start()
    }
    func ReceiptScreen(receipt: Receipt) {
        // PeopleSelectionPanCoordinator 생성
        let receiptScreenPanCoordinator = ReceiptScreenPanCoordinator(
            nav: self.nav, 
            receipt: receipt)
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
        print("\(#function)-----\(self)")
    }
}





// MARK: - 레시피 작성 델리게이트
extension SettleMoneyRoomCoordinator: ReceiptWriteDelegate {
    func successReceipt(receipt: Receipt) {
        DispatchQueue.main.async {
            if let settleMoneyVC = self.nav
                .viewControllers
                .first(where: { $0 is SettleMoneyRoomVC }) as? SettleMoneyRoomVC
            {
                settleMoneyVC.updateReceipt(with: receipt)
            }
        }
    }
}
