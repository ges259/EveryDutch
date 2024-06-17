//
//  UserProfileCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 6/12/24.
//

import UIKit

protocol UserProfileCoordProtocol: Coordinator {
    func ReceiptScreen(receipt: Receipt)
}


final class UserProfileCoordinator: UserProfileCoordProtocol {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [any Coordinator] = [] {
        didSet {
            print("**********UserProfileCoordinator**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    
    
    var nav: UINavigationController
    var modalNavController: UINavigationController?
    
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
        // 네비게이션 컨트롤러 생성 및 루트 뷰 컨트롤러 설정
        let userProfileNavController = UINavigationController(rootViewController: userProfileVC)
        
        userProfileNavController.modalPresentationStyle = .overFullScreen
        self.nav.present(userProfileNavController, animated: true)
        
        self.modalNavController = userProfileNavController
    }
    
    func ReceiptScreen(receipt: Receipt) {
        // PeopleSelectionPanCoordinator 생성
        let receiptScreenPanCoordinator = ReceiptScreenPanCoordinator(
            nav: self.modalNavController ?? self.nav,
            receipt: receipt)
        self.childCoordinators.append(receiptScreenPanCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        receiptScreenPanCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
        receiptScreenPanCoordinator.start()
    }
    func didFinish() {
        DispatchQueue.main.async {
            // 현재 표시된 뷰 컨트롤러를 dismiss
            self.modalNavController?.dismiss(animated: true)
            self.parentCoordinator?.removeChildCoordinator(child: self)
        }
    }
}
