//
//  SliderTrackView.swift
//  EveryDutch
//
//  Created by 계은성 on 4/22/24.
//

import UIKit

// MARK: - SliderTrackView
/// 슬라이더의 양옆으로 긴 타원형 트랙
final class SliderTrackView: UIView {
    typealias GradientValues = (start: UIColor, end: UIColor)
    
    // MARK: - 레이아웃
    private let gradient = CAGradientLayer()
    
    
    
    
    
    // MARK: - 프로퍼티
    var gradientValues: GradientValues = (.white, .black) {
        didSet { self.updateGradient(for: self.gradientValues) }
    }
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // gradient 레이어의 프레임을 뷰의 경계에 맞게 조정
        // 이렇게 하면 부모 뷰의 크기가 변경될 때마다 그라디언트 레이어도 같은 크기로 업데이트됩니다.
        self.gradient.frame = self.layer.bounds
        
        // gradient 레이어의 모서리를 뷰의 레이어 모서리 둥근 정도와 동일하게 설정
        // 이는 뷰의 모서리가 둥글게 설정되었다면, 그라디언트 레이어도 동일한 모양으로 둥글게 보이도록 합니다.
        self.gradient.cornerRadius = self.layer.cornerRadius
    }
    
    
    
    
    
    // MARK: - 화면 설정
    private func setupView() {
        self.gradient.masksToBounds = true
        self.gradient.actions = ["position" : NSNull(), 
                                 "bounds" : NSNull(),
                                 "path" : NSNull()]
        self.gradient.startPoint = CGPoint(x: 0, y: 0.5)
        self.gradient.endPoint = CGPoint(x: 1, y: 0.5)
        self.updateGradient(for: self.gradientValues)
        self.layer.addSublayer(self.gradient)
    }
    
    // MARK: - Gradient 업데이트
    private func updateGradient(for values: GradientValues) {
        self.gradient.colors = [values.start.cgColor, values.end.cgColor]
    }
}
