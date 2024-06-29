//
//  ImageCropView.swift
//  EveryDutch
//
//  Created by 계은성 on 4/13/24.
//

import UIKit
import SnapKit
enum ImageCropType {
    case profileImage
    case cardImage
    
    var multipliedBy: CGFloat {
        switch self {
        case .profileImage: return 1
        case .cardImage: return 1.8 / 3
        }
    }
    func createCropPath(for cropFrame: CGRect) -> UIBezierPath {
         switch self {
         case .profileImage:
             return UIBezierPath(ovalIn: cropFrame)
         case .cardImage:
             return UIBezierPath(rect: cropFrame)
         }
     }
     
     func setupCropArea(_ cropArea: UIView, cropFrame: CGRect) {
         switch self {
         case .profileImage:
             cropArea.layer.cornerRadius = cropFrame.width / 2
         case .cardImage:
             cropArea.layer.cornerRadius = 0
         }
     }
}

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
    
    private let overlayView: UIView = UIView()
    
    private let pinchGR: UIPinchGestureRecognizer = UIPinchGestureRecognizer()
    private let panGR: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    // MARK: - 프로퍼티
    weak var delegate: CustomPickerDelegate?
    
    private var currentImage: UIImage?
    var imageCropType: ImageCropType = .profileImage
    
    
    
    // MARK: - 라이프사이클
    init(imageCropType: ImageCropType) {
        super.init(frame: .zero)
        
        self.imageCropType = imageCropType
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
//        self.clipsToBounds = true
        self.setRoundedCorners(.top, withCornerRadius: 12)
        
//        self.overlayView.backgroundColor = .clear
    }
    
    /// 오토레이아웃 설정
    private func setupLayout() {
        self.addSubview(self.imageView)
        self.addSubview(self.cropArea)
        self.addSubview(self.overlayView)
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
            make.height.equalTo(self.cropArea.snp.width).multipliedBy(self.imageCropType.multipliedBy)
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
         self.overlayView].forEach {
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
            self.setupCropArea()
        }
    }
    
    /// 이미지의 높이를 설정
    private func updateImageViewHeight(aspectRatio: CGFloat) {
        // 기존에 설정된 높이 제약을 비활성화
        self.imagePickrHeight.deactivate()

        // cropArea의 가로 세로 비율을 계산
        let cropAreaAspectRatio = self.cropArea.frame.height / self.cropArea.frame.width

        // 이미지의 세로 비율이 cropArea의 세로 비율보다 작을 경우
        if aspectRatio < cropAreaAspectRatio {
            // 이미지가 cropArea보다 세로가 짧은 경우
            self.imageView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(self.cropArea.snp.height).dividedBy(aspectRatio)
                make.height.equalTo(self.cropArea.snp.height)
            }
        } else {
            // 이미지의 세로 비율이 cropArea의 세로 비율보다 큰 경우
            self.imageView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(self.cropArea.snp.width)
                make.height.equalTo(self.cropArea.snp.width).multipliedBy(aspectRatio)
            }
        }

        // 레이아웃 업데이트를 강제하여 변경 사항을 적용
        self.layoutIfNeeded()
    }
    
    /// overlayViews 설정
    private func setupOverlayViews() {
        // cropArea의 프레임을 가져옴
        let cropFrame = self.cropArea.frame

        // 오버레이 뷰의 프레임을 현재 뷰의 크기로 설정
        self.overlayView.frame = self.bounds

        // 오버레이 뷰에 기존에 추가된 서브레이어들을 제거
        self.overlayView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        // 전체 화면을 덮는 경로를 만듦
        let overlayPath = UIBezierPath(rect: self.bounds)
        // cropArea의 모양에 맞는 경로를 만듦
        let cropPath = self.imageCropType.createCropPath(for: cropFrame)

        // 오버레이 경로에 cropArea 경로를 추가
        overlayPath.append(cropPath)
        // 교차하는 부분을 제외하고 그리도록 설정
        overlayPath.usesEvenOddFillRule = true

        // 오버레이 색상을 설정하는 레이어를 만듦
        let fillLayer = CAShapeLayer()
        // fillLayer가 그릴 경로를 설정
        fillLayer.path = overlayPath.cgPath
        // 경로가 겹치는 부분의 채우기 규칙을 설정
        fillLayer.fillRule = .evenOdd
        // 오버레이 뷰의 색상을 설ㄹ정
        fillLayer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor

        // 오버레이 뷰에 레이어를 추가하여 어두운 오버레이를 설정
        self.overlayView.layer.addSublayer(fillLayer)
    }

    
    /// 크롭 영역 설정
    private func setupCropArea() {
        let cropFrame = self.cropArea.frame
        self.imageCropType.setupCropArea(self.cropArea, cropFrame: cropFrame)
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
