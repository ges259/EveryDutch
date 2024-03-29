//
//  FindFriendsCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/30.
//

import UIKit

final class FindFriendsCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********FindFriendsCoordinator**********")
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
        let findFriendsVM = FindFriendsVM(
            roomDataManager: RoomDataManager.shared,
            userAPI: UserAPI.shared, 
            roomsAPI: RoomsAPI.shared)
        // FindFriendsVC 인스턴스 생성
        let findFriendsVC = FindFriendsVC(
            coordinator: self,
            viewModel: findFriendsVM)
        self.nav.pushViewController(findFriendsVC, animated: true)
    }
    
    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    deinit {
        print("\(#function)-----\(self)")
    }
}
