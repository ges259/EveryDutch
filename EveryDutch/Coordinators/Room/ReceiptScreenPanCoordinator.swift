//
//  ReceiptScreenPanCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/04.
//

import UIKit

final class ReceiptScreenPanCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var nav: UINavigationController
    
    var receipt: Receipt
    
    
    
    // 의존성 주입
    init(nav: UINavigationController,
         receipt: Receipt) {
        self.nav = nav
        self.receipt = receipt
    }
    
    
    func start() {
        // 뷰모델 만들기
        let receiptScreenPanVM = ReceiptScreenPanVM(
            receipt: self.receipt, 
            roomDataManager: RoomDataManager.shared)
        // 뷰컨트롤러 만들기
        let receiptScreenPanVC = ReceiptScreenPanVC(
            coordinator: self,
            viewModel: receiptScreenPanVM)
        // 뒤에 화면 보이도록 설정
        receiptScreenPanVC.modalPresentationStyle = .overFullScreen
        // 화면이동 (present)
        self.nav.presentPanModal(receiptScreenPanVC)
    }
    
    func didFinish() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    deinit {
        print("\(#function)-----\(self)")
    }
}
