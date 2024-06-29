//
//  ProfileEditVCCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit
import PhotosUI
import BSImagePicker

protocol ImagePickerDelegate: AnyObject {
    func imageSelected(image: UIImage?)
}

final class EditScreenCoordinator: NSObject, EditScreenCoordProtocol {
    weak var parentCoordinator: Coordinator?
    var nav: UINavigationController
    var modalNav: UINavigationController?
    
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********MultipurposeScreenCoordinator**********")
            dump(self.childCoordinators)
            print("********************")
        }
    }
    
    
    // MARK: - Image_Fix
    weak var imageDelegate: ImagePickerDelegate?
    
    
    
    
    /// 프로필 / 유저 모드를 구분.
    /// true -> 정산방 모드,
    /// false -> 유저 모드
    private var isUserDataMode: Bool
    /// 수정 / 생성을 구분
    /// nil인 경우       -> 생성
    /// nil이 아닌 경우   -> 수정
    private var dataRequiredWhenInEidtMode: String? = nil
    /// 유저 생성 모드 플래그 (첫 로그인 시에만 활성화)
    private var isMakeUserMode: Bool
    
    
    // MARK: - 라이프사이클
    // 의존성 주입
    init(nav: UINavigationController, 
         isUserDataMode: Bool,
         isFistLoginMakeUser: Bool = false,
         DataRequiredWhenInEidtMode: String? = nil)
    {
        self.nav = nav
        // 유저 / 정산방을 구분
        self.isUserDataMode = isUserDataMode
        // 유저 생성 화면 (첫 로그인 시에만 해당)
        self.isMakeUserMode = isFistLoginMakeUser
        // 수정 / 생성을 구분
        self.dataRequiredWhenInEidtMode = DataRequiredWhenInEidtMode
    }
    deinit { print("\(#function)-----\(self)") }
    
    
    // MARK: - start
    func start() {
        self.isUserDataMode
        ? self.startUserDataMode()
        : self.startRoomDataMode()
    }
    
    
    // MARK: - 프로필 화면
    private func startUserDataMode() {
        self.moveToEditScreen {
            // ProfileEditEnum을 사용하여 ViewModel 생성
            let profileEditVM = EditScreenVM(
                screenType: ProfileEditEnum.self,
                dataRequiredWhenInEidtMode: self.dataRequiredWhenInEidtMode)
            return EditScreenVC(viewModel: profileEditVM, coordinator: self)
        }
    }

    // MARK: - 방 생성 화면
    private func startRoomDataMode() {
        self.moveToEditScreen {
            // RoomEditEnum을 사용하여 ViewModel 생성
            let roomEditVM = EditScreenVM(
                screenType: RoomEditEnum.self,
                dataRequiredWhenInEidtMode: self.dataRequiredWhenInEidtMode)
            return EditScreenVC(viewModel: roomEditVM, coordinator: self)
        }
    }
    
    // MARK: - 화면 이동
    private func moveToEditScreen(with viewModelCreation: () -> EditScreenVC) {
        let screenVC = viewModelCreation()
        screenVC.configureBackBtn(isMakeMode: self.isMakeUserMode)
        self.imageDelegate = screenVC
        self.nav.pushViewController(screenVC, animated: true)
    }
    
    
    
    // MARK: - 에러 체크 화면
    func checkReceiptPanScreen(_ validationDict: [String]) {
        // CheckReceiptCoordinator 생성
        let checkReceiptCoordinator = CheckReceiptCoordinator(
            nav: self.nav,
            type: .editScreenVC,
            validationDict: validationDict)
        self.childCoordinators.append(checkReceiptCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        checkReceiptCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
        checkReceiptCoordinator.start()
    }
    
    
    
    // MARK: - didFinish
    func didFinish() {
        DispatchQueue.main.async {
            self.nav.popViewController(animated: true)
            self.parentCoordinator?.removeChildCoordinator(child: self)
        }
    }
}
