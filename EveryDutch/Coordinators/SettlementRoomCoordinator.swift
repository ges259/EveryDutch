//
//  SettlementRoomCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit


final class SettlementRoomCoordinator: SettlementRoomCoordinating {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var nav: UINavigationController
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        // SettlementRoomVM 뷰모델 생성
        let settlementRoomVM = SettlementRoomVM()
        // PlusViewController 인스턴스 생성
        let settlementRoomVC = SettlementRoomVC(viewModel: settlementRoomVM,
                                                coordinator: self)
        // push를 통해 화면 이동
        nav.pushViewController(settlementRoomVC, animated: true)
    }
    
    func didFinish() {
        self.nav.popViewController(animated: true)
        parentCoordinator?.removeChildCoordinator(child: self)
    }
    
    deinit {
        print("deinit ----- \(#function)-----\(self)")
    }
}
