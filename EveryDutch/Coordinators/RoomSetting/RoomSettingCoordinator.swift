//
//  RoomSettingCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/28.
//

import UIKit

final class RoomSettingCoordinator: RoomSettingCoordProtocol{
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********RoomSettingCoordinator**********")
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
        let roomSettingVM = RoomSettingVM(
            roomDataManager: RoomDataManager.shared, 
            roomsAPI: RoomsAPI.shared)
        let roomSettingVC = RoomSettingVC(
            viewModel: roomSettingVM,
            coordinator: self)
        self.nav.pushViewController(roomSettingVC, animated: true)
    }
    
//    func settlementScreen() {
//        // Settlement-Coordinator 생성
//        let settlementCoordinator = SettlementCoordinator(
//            nav: self.nav)
//        self.childCoordinators.append(settlementCoordinator)
//        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
//        settlementCoordinator.parentCoordinator = self
//        // 코디네이터에게 화면이동을 지시
//        settlementCoordinator.start()
//    }
    func FindFriendsScreen() {
        // Settlement-Coordinator 생성
        let findFriendsCoordinator = FindFriendsCoordinator(
            nav: self.nav)
        self.childCoordinators.append(findFriendsCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        findFriendsCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
        findFriendsCoordinator.start()
    }
    
    func exitSuccess() {
        self.nav.popToRootViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    
    
    
    
    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(
            child: self)
    }
    deinit {
        print("\(#function)-----\(self)")
    }
}
