//
//  ProfileCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import UIKit

final class ProfileCoordinator: ProfileCoordProtocol {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var nav: UINavigationController
    
    
    
    
    // MARK: - 라이프사이클
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    deinit {
        print("\(#function)-----\(self)")
    }
    
    // MARK: - start
    func start() {
        self.profileScreen()
    }
    
    // MARK: - 프로필 화면
    private func profileScreen() {
        let profileVM = ProfileVM()
        let profileVC = ProfileVC(viewModel: profileVM,
                                  coordinator: self)
        self.nav.pushViewController(profileVC, animated: true)
    }
    
    
    
    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    
    
}
