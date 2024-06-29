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
    
    weak var imageDelegate: ImagePickerDelegate?
    
    
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
        let profileVM = ProfileVM(userAPI: UserAPI.shared)
        let profileVC = ProfileVC(viewModel: profileVM,
                                  coordinator: self)
        self.imageDelegate = profileVC
        self.nav.pushViewController(profileVC, animated: true)
    }
    
    // MARK: - 프로필 수정 화면
    func editScreen(DataRequiredWhenInEditMode: String?) {
        let editScreenVCCoordinator = EditScreenCoordinator(
            nav: self.nav,
            isUserDataMode: true,
            DataRequiredWhenInEidtMode: DataRequiredWhenInEditMode)
        self.childCoordinators.append(editScreenVCCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        editScreenVCCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
        editScreenVCCoordinator.start()
    }
    
    
    
    
    
    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
}
