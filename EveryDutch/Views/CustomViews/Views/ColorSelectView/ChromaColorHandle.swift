//
//  ChromaColorHandle.swift
//  EveryDutch
//
//  Created by 계은성 on 4/22/24.
//

import UIKit

// MARK: - ChromaColorHandle
/// 컬러 팔레트 위 핸들
final class ChromaColorHandle: UIView, ChromaControlStylable {
    
    // MARK: - 레이아웃
    private let handleShape = CAShapeLayer()
    
    /// 핸들 위에 이미지
    private let handleImage: UIImageView = {
        let img = UIImageView(image: UIImage.Exit_Img)
            img.contentMode = .scaleAspectFit
            img.tintColor = .white
        return img
    }()
    
    
    
    // MARK: - 프로퍼티
    /// Current selected color of the handle.
    var color: UIColor = .black {
        didSet { self.layoutNow() }
    }
    
    /// An image to display in the handle. Updates `accessoryView` to be a UIImageView.
    var accessoryImage: UIImage? {
        didSet {
            let imageView = UIImageView(image: self.accessoryImage)
                imageView.contentMode = .scaleAspectFit
            self.accessoryView = imageView
        }
    }
    
    /// A view to display in the handle. Overrides any previously set `accessoryImage`.
    var accessoryView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let accessoryView = self.accessoryView {
                self.addAccessoryView(accessoryView)
            }
        }
    }
    
    /// The amount an accessory view's frame should be inset by.
    var accessoryViewEdgeInsets: UIEdgeInsets = .zero {
        didSet { self.layoutNow() }
    }
    
    var borderWidth: CGFloat = 3.0 {
        didSet { self.layoutNow() }
    }
    
    var borderColor: UIColor = .white {
        didSet { self.layoutNow() }
    }
    
    var showsShadow: Bool = true {
        didSet { self.layoutNow() }
    }
    
    // MARK: - 라이프사이클
    convenience init(color: UIColor) {
        self.init(frame: .zero)
        self.color = color
        self.setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // 뷰가 서브뷰 레이아웃을 조정할 때 호출
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutHandleShape()
        self.layoutAccessoryViewIfNeeded()
        self.updateShadowIfNeeded()
        
        self.layer.masksToBounds = false
    }
    func updateShadowIfNeeded() {
        if self.showsShadow {
            let shadowProps = ShadowProperties(
                color: UIColor.black.cgColor,
                opacity: 0.3,
                offset: CGSize(width: 0, height: self.bounds.height / 8.0),
                radius: 4.0)
            self.applyDropShadow(shadowProps)
        } else {
            self.removeDropShadow()
        }
    }
    
    

    
    
    // MARK: - 화면 설정
    private func setupView() {
        self.layer.addSublayer(self.handleShape)
        
        self.accessoryView = handleImage
        self.accessoryViewEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 4, right: 4)
    }

    // MARK: - 핸들 만들기
    private func makeHandlePath(frame: CGRect) -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.minX + 0.5 * frame.width, y: frame.minY + 1 * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX + 1 * frame.width, y: frame.minY + 0.40310 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.83333 * frame.width, y: frame.minY + 0.80216 * frame.height), controlPoint2: CGPoint(x: frame.minX + 1 * frame.width, y: frame.minY + 0.60320 * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX + 0.5 * frame.width, y: frame.minY * frame.height), controlPoint1: CGPoint(x: frame.minX + 1 * frame.width, y: frame.minY + 0.18047 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.77614 * frame.width, y: frame.minY * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX * frame.width, y: frame.minY + 0.40310 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.22386 * frame.width, y: frame.minY * frame.height), controlPoint2: CGPoint(x: frame.minX * frame.width, y: frame.minY + 0.18047 * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 1 * frame.height), controlPoint1: CGPoint(x: frame.minX * frame.width, y: frame.minY + 0.60837 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.16667 * frame.width, y: frame.minY + 0.80733 * frame.height))
        path.close()
        return path.cgPath
    }
    
    // MARK: - 핸들 설정
    private func layoutHandleShape() {
        let size = CGSize(width: self.bounds.width - self.borderWidth,
                          height: self.bounds.height - self.borderWidth)
        self.handleShape.path = self.makeHandlePath(frame: CGRect(
            origin: .zero,
            size: size))
        self.handleShape.frame = CGRect(
            origin: CGPoint(x: self.bounds.midX - (size.width / 2),
                            y: self.bounds.midY - (size.height / 2)),
            size: size)
        
        self.handleShape.fillColor = self.color.cgColor
        self.handleShape.strokeColor = self.borderColor.cgColor
        self.handleShape.lineWidth = self.borderWidth
    }
    
    // MARK: - 악세사리뷰 설정
    private func layoutAccessoryViewIfNeeded() {
        if let accessoryLayer = self.accessoryView?.layer {
            let width = self.bounds.width - self.borderWidth * 2
            let size = CGSize(
                width: width - (self.accessoryViewEdgeInsets.left + self.accessoryViewEdgeInsets.right),
                height: width - (self.accessoryViewEdgeInsets.top + self.accessoryViewEdgeInsets.bottom))
            accessoryLayer.frame = CGRect(
                origin: CGPoint(
                    x: (self.borderWidth / 2) + self.accessoryViewEdgeInsets.left,
                    y: (self.borderWidth / 2) + self.accessoryViewEdgeInsets.top),
                size: size)
            
            accessoryLayer.cornerRadius = size.height / 2
            accessoryLayer.masksToBounds = true
        }
    }
    
    // MARK: - 악세사리뷰 생성
    private func addAccessoryView(_ view: UIView) {
        let accessoryLayer = view.layer
        self.handleShape.addSublayer(accessoryLayer)
    }
}
