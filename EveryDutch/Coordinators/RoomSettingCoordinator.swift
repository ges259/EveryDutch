//
//  RoomSettingCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/28.
//

import UIKit

final class RoomSettingCoordinator: RoomSettingCoordinating {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var nav: UINavigationController
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let roomSettingVC = RoomSettingVC(coordinator: self)
        self.nav.pushViewController(roomSettingVC, animated: true)
    }
    
    func settlementScreen() {
        // Settlement-Coordinator 생성
        let settlementCoordinator = SettlementCoordinator(nav: self.nav)
        self.childCoordinators.append(settlementCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        settlementCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
        settlementCoordinator.start()
    }
    
    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    deinit {
        print("deinit ----- \(#function)-----\(self)")
    }
}
