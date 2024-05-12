//
//  ProfileEditVCCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

protocol ImagePickerDelegate: AnyObject {
    func imageSelect(image: UIImage?)
//    func error()
}

final class EditScreenCoordinator: NSObject, EditScreenCoordProtocol {
    weak var parentCoordinator: Coordinator?
    var nav: UINavigationController
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********MultipurposeScreenCoordinator**********")
            dump(self.childCoordinators)
            print("********************")
        }
    }
    
    
    // MARK: - Image_Fix
    private weak var imageDelegate: ImagePickerDelegate?
    
    
    // MARK: - Color_Fix
//    private weak var colorDelegate: ColorPickerDelegate?
    private var selectedColor: UIColor?
    
    
    
    
    // 프로필 / 유저 모드를 구분
    // true -> 프로필 모드
    // false -> 유저 모드
    private var isProfileEdit: Bool
    // 수정 / 생성을 구분
    // nil인 경우       -> 생성
    // nil이 아닌 경우   -> 수정
    private var dataRequiredWhenInEidtMode: String? = nil
    // 유저 생성 모드 플래그
    private var isMakeUserMode: Bool
    
    
    // MARK: - 라이프사이클
    // 의존성 주입
    init(nav: UINavigationController, 
         isProfileEdit: Bool,
         isMakeUserMode: Bool = false,
         DataRequiredWhenInEidtMode: String? = nil)
    {
        self.nav = nav
        self.isMakeUserMode = isMakeUserMode
        self.dataRequiredWhenInEidtMode = DataRequiredWhenInEidtMode
        self.isProfileEdit = isProfileEdit
    }
    deinit { print("\(#function)-----\(self)") }
    
    
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
            let profileEditVM = EditScreenVM(
                screenType: ProfileEditEnum.self,
                dataRequiredWhenInEidtMode: self.dataRequiredWhenInEidtMode)
            
            return EditScreenVC(viewModel: profileEditVM, coordinator: self)
        }
    }

    // MARK: - 방 생성 화면
    private func startRoomEdit() {
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
        self.imageDelegate = screenVC as any ImagePickerDelegate
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








// MARK: - 이미지 피커 화면
extension EditScreenCoordinator {
    func imagePickerScreen() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.nav.present(imagePicker, animated: true)
    }
}










// MARK: - 이미지 선택 델리게이트
extension EditScreenCoordinator: UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        self.imageDelegate?.imageSelect(image: image) // 이 부분을 적절히 조정해야 합니다.
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}









































final class RoomTopView: UIView {
    // MARK: - 탑뷰
    /// 밑으로 내릴 수 있는 탑뷰
    private var topView: UIView = {
        let view = UIView.configureView(
            color: UIColor.deep_Blue)
        // 탑뷰에 그림자 추가
        view.addShadow(shadowType: .bottom)
        return view
    }()
}
