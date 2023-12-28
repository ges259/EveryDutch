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
    
    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    deinit {
        print("deinit ----- \(#function)-----\(self)")
    }
}
