//
//  ProfileEditVCCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit


protocol ColorPickerDelegate: AnyObject {
    func decorationCellChange(_ data: Any)
    
}






protocol ImagePickerDelegate: AnyObject {
    func imageSelect(image: UIImage?)
}


final class EditScreenCoordinator: NSObject, ProfileEditVCCoordProtocol {
    weak var parentCoordinator: Coordinator?

    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********MultipurposeScreenCoordinator**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    // MainCoordinator에서 설정
    weak var cardScreenDelegate: CardScreenDelegate?
    private weak var colorDelegate: ColorPickerDelegate?
    private weak var imageDelegate: ImagePickerDelegate?
    
    
    private var selectedColor: UIColor?
    
    
    
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
        self.colorDelegate = screenVC as? any ColorPickerDelegate
        self.imageDelegate = screenVC as? any ImagePickerDelegate
        self.nav.pushViewController(screenVC, animated: true)
    }
    
    
    
    // MARK: - 색상 선택 화면
    func colorPickerScreen() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self // 여기서 self는 이제 NSObject를 상속받았기 때문에 문제없이 delegate로 할당될 수 있습니다.
        self.nav.present(colorPickerVC, animated: true, completion: nil)
    }

    // MARK: - 이미지 피커 화면
    func imagePickerScreen() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.nav.present(imagePicker, animated: true, completion: nil)
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









// MARK: - CardScreenDelegate
extension EditScreenCoordinator: CardScreenDelegate {
    /// CardScreenVC에서 delegate.logout()을 호출 시 실행 됨.
    func logout() {
        self.didFinish()
        self.cardScreenDelegate?.logout()
    }
}






// MARK: - UIColorPickerViewControllerDelegate

extension EditScreenCoordinator: UIColorPickerViewControllerDelegate {
    
    // MARK: - 화면이 내려갈 때
    func colorPickerViewControllerDidFinish(
        _ viewController: UIColorPickerViewController)
    {
        if let color = self.selectedColor {
            self.colorDelegate?.decorationCellChange(color)
            self.selectedColor = nil
        }
        viewController.dismiss(animated: true)
    }
    
    // MARK: - 색상 선택 시
    func colorPickerViewControllerDidSelectColor(
        _ viewController: UIColorPickerViewController)
    {
        self.selectedColor = viewController.selectedColor
    }
}






extension EditScreenCoordinator: 
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
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
