//
//  ImageCropView.swift
//  EveryDutch
//
//  Created by 계은성 on 4/13/24.
//

import UIKit
import SnapKit

class ImageCropView: UIView, UIGestureRecognizerDelegate {
    
    private let containerView = UIView()
    
    private lazy var toolbar: ToolbarStackView = ToolbarStackView()
    
    private let imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let cropArea: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.red.cgColor
        view.backgroundColor = .clear
        view.layer.borderWidth = 2.0
        return view
    }()
    
    private let originalImage: UIImage
    private let pinchGR = UIPinchGestureRecognizer()
    private let panGR = UIPanGestureRecognizer()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var didFinishCropping: ((UIImage) -> Void)?
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    init(image: UIImage, didFinishCropping: @escaping (UIImage) -> Void) {
        self.originalImage = image
        self.didFinishCropping = didFinishCropping
        self.imageView.image = image
        
        super.init(frame: .zero)
        
        self.setupView()
        self.setupLayout()
        self.setupGestureRecognizers()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - 화면 설정
    private func setupView() {
        self.backgroundColor = UIColor.deep_Blue
        self.containerView.clipsToBounds = true
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func setupLayout() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.imageView)
        self.containerView.addSubview(self.cropArea)
        self.addSubview(self.toolbar)
        
        self.toolbar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview() // 좌우에 맞춤
            make.centerY.equalToSuperview()
            // 원본 이미지 비율 유지
            make.height.equalTo(imageView.snp.width).dividedBy(originalImage.size.width / originalImage.size.height)
        }
        self.cropArea.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview() // 가로길이 비율
            // 세로길이 비율 (aspect ratio)
            make.height.equalTo(cropArea.snp.width).multipliedBy(1.8 / 3)
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
    
    
    
    
    // MARK: - 액션 설정
    @objc func cancel() {
        // Handle cancel
    }
    
    @objc func done() {
        guard let croppedImage = self.cropImage() else { return }
        self.didFinishCropping?(croppedImage)
    }
    
    
    
    
    
    
    // MARK: - 크롭 액션
    private func cropImage() -> UIImage? {
        let scaleFactor = self.originalImage.size.width / self.imageView.frame.size.width
        let cropFrame = cropArea.frame
        
        let x = (cropFrame.origin.x - self.imageView.frame.origin.x) * scaleFactor
        let y = (cropFrame.origin.y - self.imageView.frame.origin.y) * scaleFactor
        let width = cropFrame.size.width * scaleFactor
        let height = cropFrame.size.height * scaleFactor
        let cropRect = CGRect(x: x, y: y, width: width, height: height)
        
        guard let cgImage = self.originalImage.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

    
    






// MARK: - 핀치 액션
extension ImageCropView {
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
        let kMinZoomLevel: CGFloat = 1.0
        let kMaxZoomLevel: CGFloat = 3.0
        var wentOutOfAllowedBounds = false
        
        // Prevent zooming out too much
        if transform.a < kMinZoomLevel {
            transform = .identity
            wentOutOfAllowedBounds = true
        }
        
        // Prevent zooming in too much
        if transform.a > kMaxZoomLevel {
            transform.a = kMaxZoomLevel
            transform.d = kMaxZoomLevel
            wentOutOfAllowedBounds = true
        }
        
        // Animate coming back to the allowed bounds with a haptic feedback.
        if wentOutOfAllowedBounds {
            self.generateHapticFeedback()
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.transform = transform
            })
        }
    }
    
    
    // MARK: - 햅틱 피드백
    func generateHapticFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
    
    
    
    // MARK: - 팬 액션
    @objc func pan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
        }

        if sender.state == .ended {
            self.adjustBounds()
        }
    }
    
    
    
    // MARK: - 위치 액션
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
    
    
    // MARK: - 제스쳐 설정
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
