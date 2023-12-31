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
    func FindFriendsScreen() {
        // Settlement-Coordinator 생성
        let findFriendsCoordinator = FindFriendsCoordinator(nav: self.nav)
        self.childCoordinators.append(findFriendsCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        findFriendsCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
        findFriendsCoordinator.start()
    }
    func CardScreen(_ cardScreen_Enum: CardScreen_Enum) {
        // CardScreenCoordinator 생성
        let cardScreenCoordinator = CardScreenCoordinator(
            nav: self.nav,
            cardScreen_Enum: cardScreen_Enum)
        
        cardScreenCoordinator.delegate = self
        self.childCoordinators.append(cardScreenCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        cardScreenCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
        cardScreenCoordinator.start()
    }
    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    deinit {
        print("deinit ----- \(#function)-----\(self)")
    }
}

extension RoomSettingCoordinator: MultiPurposeScreenDelegate {
    func logout() {
        print(#function)
    }
}
