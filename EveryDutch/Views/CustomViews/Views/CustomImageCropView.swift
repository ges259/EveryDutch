//
//  ImageCropView.swift
//  EveryDutch
//
//  Created by 계은성 on 4/13/24.
//

import UIKit
import SnapKit






class CustomImageCropView: UIView, UIGestureRecognizerDelegate {
    
    
    
    private lazy var toolbar: ToolbarStackView = {
        let toolbar = ToolbarStackView()
            toolbar.delegate = self
        return toolbar
    }()
    
    private let imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    private var imagePickrHeight: Constraint!
    
    
    private let cropArea: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.red.cgColor
        view.backgroundColor = .clear
        view.layer.borderWidth = 2.0
        return view
    }()
    
    
    private let pinchGR: UIPinchGestureRecognizer = UIPinchGestureRecognizer()
    private let panGR: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    weak var delegate: CustomPickerDelegate?
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupView()
        self.setupLayout()
        self.setupGestureRecognizers()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










// MARK: - 기본 설정

extension CustomImageCropView {
    
    // MARK: - 화면 설정
    private func setupView() {
        self.backgroundColor = UIColor.deep_Blue
        self.clipsToBounds = true
        
        
        self.addShadow(shadowType: .top)
        
        self.setRoundedCorners(.top, withCornerRadius: 12)
    }
    
    // MARK: - 오토레이아웃 설정
    private func setupLayout() {
        self.addSubview(self.imageView)
        self.addSubview(self.cropArea)
        self.addSubview(self.toolbar)
        
        self.toolbar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        self.imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            self.imagePickrHeight = make.height.equalTo(0).constraint
        }
        self.cropArea.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(self.cropArea.snp.width).multipliedBy(1.8 / 3)
        }
    }
    
    // MARK: - 제스쳐 설정
    private func setupGestureRecognizers() {
        self.pinchGR.addTarget(self, action: #selector(self.pinch(_:)))
        self.panGR.addTarget(self, action: #selector(self.pan(_:)))
        self.imageView.addGestureRecognizer(self.pinchGR)
        self.imageView.addGestureRecognizer(self.panGR)
        self.imageView.isUserInteractionEnabled = true
        self.cropArea.isUserInteractionEnabled = false
    }
}
    
    
    
    
    
    
    
    
    

extension CustomImageCropView {
    
    // MARK: - 이미지 설정
    func setupImage(image: UIImage?) {
        guard let image = image else {
            self.imageView.image = nil
            return
        }
        // 이미지 바꾸기
        self.imageView.image = image
        // imageView 비율 업데이트
        self.updateImageViewHeight(aspectRatio: image.size.height / image.size.width)
    }
    /// 이미지 뷰의 높이 제약 조건을 업데이트하는 함수
    private func updateImageViewHeight(aspectRatio: CGFloat) {
        // 기존의 높이 제약 조건을 비활성화
        self.imagePickrHeight.deactivate()
        // 새로운 높이 제약 조건을 설정
        self.imageView.snp.makeConstraints { make in
            self.imagePickrHeight = make.height.equalTo(self.imageView.snp.width).multipliedBy(aspectRatio).constraint
        }
        // 레이아웃 업데이트
        self.layoutIfNeeded()
        self.changeCardImageView()
    }
    
    
    
    // MARK: - 크롭 액션
    private func cropImage() -> UIImage? {
        // 이미지 옵셔널 바인딩
        guard let image = self.imageView.image else { return nil }
        
        let scaleFactor = image.size.width / self.imageView.frame.size.width
        let cropFrame = self.cropArea.frame
        
        let x = (cropFrame.origin.x - self.imageView.frame.origin.x) * scaleFactor
        let y = (cropFrame.origin.y - self.imageView.frame.origin.y) * scaleFactor
        let width = cropFrame.size.width * scaleFactor
        let height = cropFrame.size.height * scaleFactor
        let cropRect = CGRect(x: x, y: y, width: width, height: height)
        
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

    
    







// MARK: - 핀치 액션
extension CustomImageCropView {
    @objc func pinch(_ sender: UIPinchGestureRecognizer) {
        // TODO: Zoom where the fingers are (more user friendly)
        switch sender.state {
        case .began, .changed:
            var transform = self.imageView.transform
            // Apply zoom level.
            transform = transform.scaledBy(x: sender.scale,
                                           y: sender.scale)
            self.imageView.transform = transform
        case .ended:
            self.pinchGestureEnded()
            self.adjustBounds()
            
        case .cancelled, .failed, .possible:
            ()
        @unknown default:
            print("Error")
        }
        // Reset the pinch scale.
        sender.scale = 1.0
    }
    
    // MARK: - 종료 시
    private func pinchGestureEnded() {
        var transform = self.imageView.transform
        let kMinZoomLevel: CGFloat = 1.0 // 최소 줌 레벨을 정의
        let kMaxZoomLevel: CGFloat = 3.0 // 최대 줌 레벨을 정의
        var wentOutOfAllowedBounds = false // 허용된 범위를 벗어났는지를 확인하는 플래그

        // 너무 많이 축소하는 것을 방지
        if transform.a < kMinZoomLevel {
            transform = .identity // 변형을 초기 상태(1:1 비율)로 리셋
            wentOutOfAllowedBounds = true // 허용된 범위를 벗어났다고 표시
        }
        // 너무 많이 확대하는 것을 방지
        if transform.a > kMaxZoomLevel {
            transform.a = kMaxZoomLevel // 최대 줌 레벨로 제한
            transform.d = kMaxZoomLevel // 줌 레벨을 동일하게 설정하여 일관성을 유지
            wentOutOfAllowedBounds = true // 허용된 범위를 벗어났다고 표시
        }
        
        // 허용된 범위를 벗어난 경우 애니메이션과 함께 원래 범위로 돌아오게 함
        if wentOutOfAllowedBounds {
            // 햅틱 피드백을 생성합니다.
            self.generateHapticFeedback()
            // 이미지 뷰의 변형을 애니메이션과 함께 적용
            UIView.animate(withDuration: 0.3) {
                self.imageView.transform = transform
            }
        }
    }
    
    
    // MARK: - 햅틱 피드백
    func generateHapticFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
}
    
    
    
    
    
    
    



// MARK: - 팬 액션
extension CustomImageCropView {
    @objc func pan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        if let view = sender.view {
            self.imageView.center = CGPoint(
                x: self.imageView.center.x + translation.x,
                y: self.imageView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
        }
        if sender.state == .ended {
            self.adjustBounds()
        }
    }
    
    // MARK: - 화면 위치 재조정
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
            UIView.animate(withDuration: 0.3) {
                self.imageView.frame = correctedFrame
            }
        }
        self.changeCardImageView()
    }
    
    private func changeCardImageView() {
        // 이미지 크롭하기
        guard let cropedImage = self.cropImage() else { return }
        // 크롭한 이미지 전달
        self.delegate?.changedCropLocation(data: cropedImage)
    }
    
    
    // MARK: - 제스쳐 설정
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}











// MARK: - 툴바 델리게이트
extension CustomImageCropView: ToolbarDelegate {
    func cancelBtnTapped() {
        self.delegate?.cancel(type: .imagePicker)
    }
    
    func saveBtnTapped() {
        guard let croppedImage = self.cropImage() else { return }
        self.delegate?.done(with: croppedImage)
    }
}
