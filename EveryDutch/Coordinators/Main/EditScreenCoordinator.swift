//
//  ProfileEditVCCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit
import YPImagePicker

protocol ColorPickerDelegate: AnyObject {
    func decorationCellChange(_ data: UIColor)
    
}

protocol ImagePickerDelegate: AnyObject {
    func imageSelect(image: UIImage?)
//    func error()
}

final class EditScreenCoordinator: NSObject, ProfileEditVCCoordProtocol {
    weak var parentCoordinator: Coordinator?
    var nav: UINavigationController
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********MultipurposeScreenCoordinator**********")
            dump(self.childCoordinators)
            print("********************")
        }
    }
    
    
    // MainCoordinator에서 설정
    weak var editScreenDelegate: EditScreenDelegate?
    
    // MARK: - Image_Fix
    private weak var imageDelegate: ImagePickerDelegate?
    
    
    // MARK: - Color_Fix
    private weak var colorDelegate: ColorPickerDelegate?
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
        // MARK: - Color_Fix
//        self.colorDelegate = screenVC as any ColorPickerDelegate
        self.imageDelegate = screenVC as any ImagePickerDelegate
        self.nav.pushViewController(screenVC, animated: true)
    }
    
    // MARK: - didFinish
    func didFinish() {
        DispatchQueue.main.async {
            self.nav.popViewController(animated: true)
            self.parentCoordinator?.removeChildCoordinator(child: self)
        }
    }
}










// MARK: - CardScreenDelegate
extension EditScreenCoordinator: EditScreenDelegate {
    
    func makeProviderData(with: EditProviderModel) {
        self.didFinish()
        self.editScreenDelegate?.makeProviderData(with: with)
    }
}










// MARK: - 이미지 피커 화면
extension EditScreenCoordinator {
    
    
    func imagePickerScreen() {
//        let image = UIImage(named: "practice2")
//        guard let image = image else { return }
//        let ypcropVC = YPCropVC(image: image)
//        ypcropVC.modalPresentationStyle = .fullScreen
//        self.nav.present(ypcropVC, animated: true)
//        self.nav.presentPanModal(ypcropVC)
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










// MARK: - 색상 선택 화면
extension EditScreenCoordinator {
    func colorPickerScreen() {
//        let colorPickerVC = UIColorPickerViewController()
//        
//        // MARK: - Color_Fix
//        colorPickerVC.delegate = self // 여기서 self는 이제 NSObject를 상속받았기 때문에 문제없이 delegate로 할당될 수 있습니다.
//        self.nav.present(colorPickerVC, animated: true, completion: nil)
        
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        self.nav.present(colorPickerVC, animated: true, completion: nil)
    }
}





// MARK: - Fix




// MARK: - 색상 선택 델리게이트

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


















































































import SnapKit
import PanModal

class ImageCropView: UIView, UIGestureRecognizerDelegate {
    
    let containerView = UIView()
    
    let imageView = UIImageView()
    let toolbar = UIToolbar()
    let cropArea = UIView()
    var didFinishCropping: ((UIImage) -> Void)?

    private let originalImage: UIImage
    private let pinchGR = UIPinchGestureRecognizer()
    private let panGR = UIPanGestureRecognizer()

    init(image: UIImage, didFinishCropping: @escaping (UIImage) -> Void) {
        self.originalImage = image
        self.didFinishCropping = didFinishCropping
        super.init(frame: .zero)
        setupViewHierarchy()
        setupLayout()
        setupGestureRecognizers()
        
        
        self.backgroundColor = .blue
        
        containerView.clipsToBounds = true
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        cropArea.layer.borderColor = UIColor.red.cgColor
        cropArea.layer.borderWidth = 2.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(cropArea)
        containerView.addSubview(toolbar)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(done))
        toolbar.items = [cancelButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), saveButton]
    }

    private func setupLayout() {
        
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview() // 좌우에 맞춤
            make.centerY.equalToSuperview() // 세로 중심에 맞춤
            make.height.equalTo(imageView.snp.width).dividedBy(originalImage.size.width / originalImage.size.height) // 원본 이미지 비율 유지
        }
        
        cropArea.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview() // 가로길이 비율
            make.height.equalTo(cropArea.snp.width).multipliedBy(1.8 / 3) // 세로길이 비율 (aspect ratio)
        }
        
        toolbar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }

    private func setupGestureRecognizers() {
        pinchGR.addTarget(self, action: #selector(pinch(_:)))
        panGR.addTarget(self, action: #selector(pan(_:)))
        imageView.addGestureRecognizer(pinchGR)
        imageView.addGestureRecognizer(panGR)
        imageView.isUserInteractionEnabled = true
    }

    @objc func cancel() {
        // Handle cancel
    }

    @objc func done() {
        guard let croppedImage = cropImage() else { return }
        didFinishCropping?(croppedImage)
    }

    private func cropImage() -> UIImage? {
        let scaleFactor = originalImage.size.width / imageView.frame.size.width
        let cropFrame = cropArea.frame
        
        let x = (cropFrame.origin.x - imageView.frame.origin.x) * scaleFactor
        let y = (cropFrame.origin.y - imageView.frame.origin.y) * scaleFactor
        let width = cropFrame.size.width * scaleFactor
        let height = cropFrame.size.height * scaleFactor
        let cropRect = CGRect(x: x, y: y, width: width, height: height)

        guard let cgImage = originalImage.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    @objc func pinch(_ sender: UIPinchGestureRecognizer) {
        guard let view = sender.view else { return }
        if sender.state == .began || sender.state == .changed {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1.0
        }
    }
    @objc func pan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
        }

        if sender.state == .ended {
            adjustBounds()
        }
    }
    private func adjustBounds() {
        let imageRect = self.imageView.frame
        let cropRect = self.cropArea.frame
        var correctedFrame = imageRect
        
        // Cap Top.
        if imageRect.minY > cropRect.minY {
            correctedFrame.origin.y = cropRect.minY
        }
        
        // Cap Bottom.
        if imageRect.maxY < cropRect.maxY {
            correctedFrame.origin.y = cropRect.maxY - imageRect.height
        }
        
        // Cap Left.
        if imageRect.minX > cropRect.minX {
            correctedFrame.origin.x = cropRect.minX
        }
        
        // Cap Right.
        if imageRect.maxX < cropRect.maxX {
            correctedFrame.origin.x = cropRect.maxX - imageRect.width
        }
        
        // Animate back to allowed bounds
        if imageRect != correctedFrame {
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.frame = correctedFrame
            })
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
