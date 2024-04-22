//
//  ColorWheelView.swift
//  EveryDutch
//
//  Created by 계은성 on 4/22/24.
//

import UIKit
import SnapKit

private let defaultImageViewCurveInset: CGFloat = 1.0

// MARK: - ColorWheelView
/// 이미지 피커의 색상을 표시하는 아이콘 뷰
final class ColorWheelView: UIView {
    
    // MARK: - 레이아웃
    private let imageView: UIImageView = {
        let img = UIImageView()
            img.contentMode = .scaleAspectFit
        return img
    }()
    private let imageViewMask = UIView.configureView(color: .black)
    
    
    
    
    
    // MARK: - 프로퍼티
    // 원의 반지름 계산
    var radius: CGFloat {
        return max(bounds.width, bounds.height) / 2.0
    }
    // 중심점 계산
    var middlePoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupImageView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // 뷰가 서브뷰 레이아웃을 조정할 때 호출
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.radius
        // MARK: - Fix
        if let colorWheelCIImage = self.makeColorWheelImage(radius: self.radius * UIScreen.main.scale) {
            let context = CIContext(options: nil)
            if let colorWheelCGImage = context.createCGImage(colorWheelCIImage, from: colorWheelCIImage.extent) {
                let colorWheelUIImage = UIImage(cgImage: colorWheelCGImage)
                self.imageView.image = colorWheelUIImage
            }
        }
        // 이미지 뷰를 마스크하여 색상 휠의 가장자리가 부드럽게 처리됨
        self.imageViewMask.frame = self.imageView.bounds.insetBy(
            dx: defaultImageViewCurveInset, 
            dy: defaultImageViewCurveInset)
        self.imageViewMask.layer.cornerRadius = self.imageViewMask.bounds.width / 2.0
        self.imageView.mask = self.imageViewMask
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 화면 설정
    private func setupView() {
        self.backgroundColor = .clear
    }
    
    // MARK: - 오토레이아웃 설정
    private func setupImageView() {
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.size.equalToSuperview().inset(-defaultImageViewCurveInset * 2)
            make.center.equalToSuperview()
        }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 색상 위치 계산
    func location(of color: UIColor) -> CGPoint {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: nil, alpha: nil)
        
        let radianAngle = hue * (2 * .pi)
        let distance = saturation * self.radius
        let colorTranslation = CGPoint(x: distance * cos(radianAngle),
                                       y: -distance * sin(radianAngle))
        let colorPoint = CGPoint(x: bounds.midX + colorTranslation.x,
                                 y: bounds.midY + colorTranslation.y)
        return colorPoint
    }
    
    // MARK: - 특정 포인트의 색상 반환
    func pixelColor(at point: CGPoint) -> UIColor? {
        guard self.pointIsInColorWheel(point) else { return nil }
        
        guard !self.pointIsOnColorWheelEdge(point) else {
            let angleToCenter = atan2(point.x - self.middlePoint.x, point.y - self.middlePoint.y)
            return self.edgeColor(for: angleToCenter)
        }
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(
            data: pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            return nil
        }
        
        context.translateBy(x: -point.x, y: -point.y)
        self.imageView.layer.render(in: context)
        let color = UIColor(
            red: CGFloat(pixel[0]) / 255.0,
            green: CGFloat(pixel[1]) / 255.0,
            blue: CGFloat(pixel[2]) / 255.0,
            alpha: 1.0
        )
        
        pixel.deallocate()
        return color
    }
    
    // MARK: - 색상 휠 내의 포인트 판별
    func pointIsInColorWheel(_ point: CGPoint) -> Bool {
        guard bounds.insetBy(dx: -1, dy: -1).contains(point) else { return false }
        
        let distanceFromCenter: CGFloat = hypot(self.middlePoint.x - point.x, self.middlePoint.y - point.y)
        let pointExistsInRadius: Bool = distanceFromCenter <= (radius - layer.borderWidth)
        return pointExistsInRadius
    }
    
    // MARK: - 색상 휠 가장자리 판별
    private func pointIsOnColorWheelEdge(_ point: CGPoint) -> Bool {
        let distanceToCenter = hypot(self.middlePoint.x - point.x, self.middlePoint.y - point.y)
        let isPointOnEdge = distanceToCenter >= self.radius - 1.0
        return isPointOnEdge
    }
    
    // MARK: - 색상 휠 이미지 생성
    private func makeColorWheelImage(radius: CGFloat) -> CIImage? {
        let filter = CIFilter(
            name: "CIHueSaturationValueGradient",
            parameters: [
                "inputColorSpace": CGColorSpaceCreateDeviceRGB(),
                "inputDither": 0,
                "inputRadius": radius,
                "inputSoftness": 0,
                "inputValue": 1
            ])
        // CIImage를 생성하여 반환
        return filter?.outputImage?.cropped(to: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
    }
    
    // MARK: - 색상 휠 가장자리 색상 계산
    private func edgeColor(for angle: CGFloat) -> UIColor {
        var normalizedAngle = angle + .pi // normalize to [0, 2pi]
        normalizedAngle += (.pi / 2) // rotate pi/2 for color wheel
        var hue = normalizedAngle / (2 * .pi)
        if hue > 1 { hue -= 1 }
        return UIColor(hue: hue, saturation: 1, brightness: 1.0, alpha: 1.0)
    }
}
