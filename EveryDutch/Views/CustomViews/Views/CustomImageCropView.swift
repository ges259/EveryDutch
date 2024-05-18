//
//  ImageCropView.swift
//  EveryDutch
//
//  Created by 계은성 on 4/13/24.
//

import UIKit
import SnapKit

class CustomImageCropView: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - 레이아웃
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
            view.layer.borderColor = UIColor.white.cgColor
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

// MARK: - 이미지 설정 및 크롭
extension CustomImageCropView {
    /// 이미지 설정
    func setupImage(image: UIImage?) {
        guard let image = image else {
            self.imageView.image = nil
            return
        }
        self.imageView.image = image.fixedOrientation()
        self.updateImageViewHeight(aspectRatio: image.size.height / image.size.width)
    }
    /// 이미지의 높이를 설정
    private func updateImageViewHeight(aspectRatio: CGFloat) {
        self.imagePickrHeight.deactivate()
        self.imageView.snp.makeConstraints { make in
            self.imagePickrHeight = make.height.equalTo(self.imageView.snp.width).multipliedBy(aspectRatio).constraint
        }
        self.layoutIfNeeded()
        self.changeCardImageView()
    }
    /// 크롭 액션
    private func cropImage() -> UIImage? {
        guard let image = self.imageView.image else { return nil }
        
        let scaleFactor = image.size.width / self.imageView.frame.size.width
        let cropFrame = self.cropArea.frame
        
        let x = (cropFrame.origin.x - self.imageView.frame.origin.x) * scaleFactor
        let y = (cropFrame.origin.y - self.imageView.frame.origin.y) * scaleFactor
        let width = cropFrame.size.width * scaleFactor
        let height = cropFrame.size.height * scaleFactor
        let cropRect = CGRect(x: x, y: y, width: width, height: height)
        
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return nil }
        let croppedImage = UIImage(cgImage: cgImage)
        
        return croppedImage.fixedOrientation()
    }
}










// MARK: - 핀치 액션
extension CustomImageCropView {
    @objc func pinch(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            var transform = self.imageView.transform
            transform = transform.scaledBy(x: sender.scale, y: sender.scale)
            self.imageView.transform = transform
        case .ended:
            self.pinchGestureEnded()
            self.adjustBounds()
        case .cancelled, .failed, .possible:
            break
        @unknown default:
            print("Error")
        }
        sender.scale = 1.0
    }
    
    private func pinchGestureEnded() {
        var transform = self.imageView.transform
        let kMinZoomLevel: CGFloat = 1.0
        let kMaxZoomLevel: CGFloat = 3.0
        var wentOutOfAllowedBounds = false
        
        if transform.a < kMinZoomLevel {
            transform = .identity
            wentOutOfAllowedBounds = true
        }
        
        if transform.a > kMaxZoomLevel {
            transform.a = kMaxZoomLevel
            transform.d = kMaxZoomLevel
            wentOutOfAllowedBounds = true
        }
        
        if wentOutOfAllowedBounds {
            self.generateHapticFeedback()
            UIView.animate(withDuration: 0.3) {
                self.imageView.transform = transform
            }
        }
    }
    
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
    
    private func adjustBounds() {
        let imageRect = self.imageView.frame
        let cropRect = self.cropArea.frame
        var correctedFrame = imageRect
        
        if imageRect.minY > cropRect.minY {
            correctedFrame.origin.y = cropRect.minY
        }
        
        if imageRect.maxY < cropRect.maxY {
            correctedFrame.origin.y = cropRect.maxY - imageRect.height
        }
        
        if imageRect.minX > cropRect.minX {
            correctedFrame.origin.x = cropRect.minX
        }
        
        if imageRect.maxX < cropRect.maxX {
            correctedFrame.origin.x = cropRect.maxX - imageRect.width
        }
        
        if imageRect != correctedFrame {
            UIView.animate(withDuration: 0.3) {
                self.imageView.frame = correctedFrame
            }
        }
        self.changeCardImageView()
    }
    
    private func changeCardImageView() {
        guard let croppedImage = self.cropImage() else { return }
        self.delegate?.changedCropLocation(data: croppedImage)
    }
    
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
