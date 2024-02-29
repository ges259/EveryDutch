//
//  ProfileEditVCCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

final class EditScreenVCCoordinator: ProfileEditVCCoordProtocol {
    weak var parentCoordinator: Coordinator?

    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********MultipurposeScreenCoordinator**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    // MainCoordinator에서 설정
    weak var delegate: CardScreenDelegate?
    
    var nav: UINavigationController
    
    private var isProfileEdit: Bool
    private var isMake: Bool
    
    
    
    
    // MARK: - 라이프사이클
    // 의존성 주입
    init(nav: UINavigationController, 
         isProfileEdit: Bool,
         isMake: Bool)
    {
        self.nav = nav
        self.isMake = isMake
        self.isProfileEdit = isProfileEdit
    }
    
    // MARK: - start
    func start() {
        self.isProfileEdit
        ? self.startProfileEdit()
        : self.startRoomEdit()
    }
    
    
    
    // MARK: - 프로필 화면
    private func startProfileEdit() {
        self.moveToEditScreen {
            // ProfileEditEnum을 사용하여 ViewModel 생성
            let profileEditVM = EditScreenVM(isMake: self.isMake,
                                             editScreenType: ProfileEditEnum.self)
            return EditScreenVC(viewModel: profileEditVM, coordinator: self)
        }
    }

    // MARK: - 방 생성 화면
    private func startRoomEdit() {
        self.moveToEditScreen {
            // RoomEditEnum을 사용하여 ViewModel 생성
            let roomEditVM = EditScreenVM(isMake: self.isMake,
                                          editScreenType: RoomEditEnum.self)
            return EditScreenVC(viewModel: roomEditVM, coordinator: self)
        }
    }
    
    // MARK: - 화면 이동
    private func moveToEditScreen(with viewModelCreation: () -> UIViewController) {
        let screenVC = viewModelCreation()
        self.nav.pushViewController(screenVC, animated: true)
    }
    
    
    
    
    // MARK: - didFinish
    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    deinit {
        print("\(#function)-----\(self)")
    }
}










extension EditScreenVCCoordinator: CardScreenDelegate {
    /// CardScreenVC에서 delegate.logout()을 호출 시 실행 됨.
    func logout() {
        self.didFinish()
        (self.parentCoordinator as? MainCoordinator)?.logout()
    }
}
