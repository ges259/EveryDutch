//
//  MainCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

// MARK: - MainViewController
final class MainCoordinator: MainCoordProtocol{
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********MainCoordinator**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    
    var nav: UINavigationController
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    // MainViewController 띄우기
    func start() {
        // 뷰모델 인스턴스 생성 (이 부분이 추가됨)
        let mainViewModel = MainVM(
            roomsAPI: RoomsAPI.shared)
        // 뷰컨트롤러 인스턴스 생성 및 뷰모델 주입
        let mainVC = MainVC(viewModel: mainViewModel,
                            coordinator: self)
        // 화면 전환
        self.nav.pushViewController(mainVC, animated: true)
    }
    
    /// 채팅방으로 이동
    func settlementMoneyRoomScreen(room: Rooms) {
        // SettleMoneyRoomCoordinator 생성
        let settlementRoomCoordinator = SettleMoneyRoomCoordinator(
            nav: self.nav,
            room: room)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
            settlementRoomCoordinator.parentCoordinator = self
        self.childCoordinators.append(settlementRoomCoordinator)
            settlementRoomCoordinator.start()
    }
    
    /// 플러스 버튼을 누르면 화면 이동
    func cardScreen(_ cardScreen_Enum: CardScreen_Enum) {
        // Main-Coordinator 생성
        let multipurposeScreenCoordinator = CardScreenCoordinator(
            nav: self.nav,
            cardScreen_Enum: cardScreen_Enum)
        
        multipurposeScreenCoordinator.delegate = self
        self.childCoordinators.append(multipurposeScreenCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
            multipurposeScreenCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
            multipurposeScreenCoordinator.start()
    }
    
    func selectALgoinMethodScreen() {
        // SettleMoneyRoomCoordinator 생성
        let selectALoginMethodCoordinator = SelectALoginMethodCoordinator(nav: self.nav)
        self.childCoordinators.append(selectALoginMethodCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        selectALoginMethodCoordinator.parentCoordinator = self
        selectALoginMethodCoordinator.start()
    }
    
    
    
    func profileScreen() {
        print(#function)
    }
    
    func didFinish() {}
    
    deinit {
        print("deinit ----- \(#function)-----\(self)")
    }
}

extension MainCoordinator: MultiPurposeScreenDelegate {
    func logout() {
        // SettleMoneyRoomCoordinator 생성
        let selectALoginMethodCoordinator = SelectALoginMethodCoordinator(nav: self.nav)
        self.childCoordinators.append(selectALoginMethodCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        selectALoginMethodCoordinator.parentCoordinator = self
        selectALoginMethodCoordinator.start()
    }
}
