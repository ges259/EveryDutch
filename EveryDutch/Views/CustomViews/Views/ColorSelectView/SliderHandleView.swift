//
//  SliderHandleView.swift
//  EveryDutch
//
//  Created by 계은성 on 4/22/24.
//

import UIKit

// MARK: - SliderHandleView
/// 슬라이더의 --- 삼각형 모향 핸들 설정
final class SliderHandleView: UIView {
    
    // MARK: - 레아아웃
    private let handleLayer = CAShapeLayer()
    
    
    
    
    
    // MARK: - 프로퍼티
    var handleColor: UIColor = .black {
        didSet { self.updateHandleColor(to: self.handleColor) }
    }
    
    var borderWidth: CGFloat = 3.0 {
        didSet { self.layoutNow() }
    }
    
    var borderColor: UIColor = .white {
        didSet { self.layoutNow() }
    }
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.updateHandleColor(to: self.handleColor)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // 뷰가 서브뷰 레이아웃을 조정할 때 호출
    override func layoutSubviews() {
        let radius: CGFloat = bounds.height / 10
        self.handleLayer.path = makeRoundedTrianglePath(
            width: self.bounds.width,
            height: self.bounds.height,
            radius: radius)
        self.handleLayer.strokeColor = self.borderColor.cgColor
        self.handleLayer.lineWidth = self.borderWidth
        self.handleLayer.position = CGPoint(
            x: self.bounds.width / 2,
            y: (self.bounds.height / 2.0) - (radius / 4.0))
    }
    
    
    
    
    
    // MARK: - 화면 설정
    private func setupView() {
        self.layer.addSublayer(self.handleLayer)
        
    }
    
    // MARK: - 핸들 색상 설정
    private func updateHandleColor(to color: UIColor) {
        self.handleLayer.fillColor = color.cgColor
    }
    
    // MARK: - 슬라이더 설정
    private func makeRoundedTrianglePath(width: CGFloat, height: CGFloat, radius: CGFloat) -> CGPath {
        let point1 = CGPoint(x: -width / 2, y: height / 2)
        let point2 = CGPoint(x: 0, y: -height / 2)
        let point3 = CGPoint(x: width / 2, y: height / 2)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height / 2))
        path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
        path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)
        path.addArc(tangent1End: point3, tangent2End: point1, radius: radius)
        path.closeSubpath()
        
        return path
    }
}
