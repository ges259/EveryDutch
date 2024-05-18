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
            view.layer.borderWidth = 2.5
        return view
    }()
    
    private let overlayViewTop: UIView = UIView()
    private let overlayViewBottom: UIView = UIView()
    
    private let pinchGR: UIPinchGestureRecognizer = UIPinchGestureRecognizer()
    private let panGR: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    
    
    
    
    // MARK: - 프로퍼티
    weak var delegate: CustomPickerDelegate?
    
    private var currentImage: UIImage?
    
    
    
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

// MARK: - 화면 기본 설정
extension CustomImageCropView {
    /// 화면 설정
    private func setupView() {
        self.backgroundColor = UIColor.deep_Blue
        self.clipsToBounds = true
        self.setRoundedCorners(.top, withCornerRadius: 12)
        
        [self.overlayViewTop, self.overlayViewBottom].forEach {
            $0.backgroundColor = .black.withAlphaComponent(0.5)
        }
    }
    
    /// 오토레이아웃 설정
    private func setupLayout() {
        self.addSubview(self.imageView)
        self.addSubview(self.cropArea)
        self.addSubview(self.overlayViewTop)
        self.addSubview(self.overlayViewBottom)
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
    
    /// 제스쳐 설정
    private func setupGestureRecognizers() {
        self.pinchGR.addTarget(self, action: #selector(self.pinch(_:)))
        self.panGR.addTarget(self, action: #selector(self.pan(_:)))
        self.imageView.addGestureRecognizer(self.pinchGR)
        self.imageView.addGestureRecognizer(self.panGR)
        self.imageView.isUserInteractionEnabled = true
        
        [self.cropArea,
         self.overlayViewTop,
         self.overlayViewBottom].forEach {
            $0.isUserInteractionEnabled = false
        }
    }
}










// MARK: - 화면에 들어설 때 설정
extension CustomImageCropView {
    /// 이미지 설정
    func setupImage(image: UIImage?) {
        guard let image = image else {
            self.imageView.image = nil
            return
        }
        self.imageView.image = image.fixedOrientation()
        self.updateImageViewHeight(aspectRatio: image.size.height / image.size.width)
        // DispatchQueue.main.async를 사용함으로써 비동기 작업 후 오버레이 업데이트
        // 만약 사용하지 않는다면, 정상적으로 작동하지 않음
        DispatchQueue.main.async {
            self.setupOverlayViews()
        }
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
    
    /// overlayViews 설정
    private func setupOverlayViews() {
        let cropFrame = self.cropArea.frame
        self.overlayViewTop.frame = CGRect(
            x: 0,
            y: 0,
            width: self.bounds.width,
            height: cropFrame.minY)
        self.overlayViewBottom.frame = CGRect(
            x: 0,
            y: cropFrame.maxY,
            width: self.bounds.width,
            height: self.bounds.height - cropFrame.maxY)
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
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.imageView.transform = transform
            }
        }
    }
    
    // MARK: - 팬 액션
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
}





// MARK: - 위치 조정 액션 이후 메서드
extension CustomImageCropView {
    /// pinch 및 pan액선 후 위치 재조정
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
    /// 이미지를 크롭 후, EditScreenVC(-> CardImgView)로 delegate 전달
    private func changeCardImageView() {
        guard let croppedImage = self.cropImage() else { return }
        self.currentImage = croppedImage
        self.delegate?.changedCropLocation(data: croppedImage)
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
    
    
    // 제스쳐 관련 설정
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
        self.delegate?.done(with: self.currentImage)
    }
}
