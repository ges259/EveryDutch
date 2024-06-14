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
    let userDecoTuple: UserDecoTuple
    
    // 의존성 주입
    init(nav: UINavigationController,
         userDecoTuple: UserDecoTuple) {
        self.nav = nav
        self.userDecoTuple = userDecoTuple
    }
    deinit { print("\(#function)-----\(self)") }
    
    
    func start() {
        self.userProfileScreen()
    }
    
    private func userProfileScreen() {
        let userProfileVM = UserProfileVM(
            roomDataManager: RoomDataManager.shared,
            userDecoTuple: self.userDecoTuple)
        let userProfileVC = UserProfileVC(
            viewModel: userProfileVM,
            coordinator: self)
        self.nav.presentPanModal(userProfileVC)
    }
    
    
    func didFinish() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
}
