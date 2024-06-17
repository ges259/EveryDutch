//
//  UserProfileCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 6/12/24.
//

import UIKit

final class UserProfileCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [any Coordinator] = [] {
        didSet {
            print("**********UserProfileCoordinator**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    
    
    var nav: UINavigationController
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    deinit { print("\(#function)-----\(self)") }
    
    
    func start() {
        self.userProfileScreen()
    }
    
    private func userProfileScreen() {
        let userProfileVM = UserProfileVM(
            roomDataManager: RoomDataManager.shared)
        let userProfileVC = UserProfileVC(
            viewModel: userProfileVM,
            coordinator: self)
//        self.nav.presentPanModal(userProfileVC)
        userProfileVC.modalPresentationStyle = .overFullScreen
        self.nav.present(userProfileVC, animated: true)
    }
    
    
    func didFinish() {
        self.nav.dismiss(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
}

/*
 .contentHeight(self.cardHeight() + self.btnSize + 17 + 10 + UIDevice.current.panModalSafeArea)
}
 */
