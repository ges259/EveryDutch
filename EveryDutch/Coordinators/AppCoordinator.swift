//
//  AppCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

// MARK: - AppCoordinator
final class AppCoordinator: Coordinator {
    
    
    let nav: UINavigationController
    // 순환 참조 방지, weak 사용
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        self.showMainScreen()
    }
    
    /// 메인화면으로 이동
    func showMainScreen() {
        // Main-Coordinator 생성
        let mainCoordinator = MainCoordinator(nav: self.nav)
            mainCoordinator.parentCoordinator = self
        self.childCoordinators.append(mainCoordinator)
            mainCoordinator.start()
    }
    
    func didFinish() {}
}
