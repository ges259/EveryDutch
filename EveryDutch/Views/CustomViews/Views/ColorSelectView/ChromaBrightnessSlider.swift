//
//  ChromaBrightnessSlider.swift
//  EveryDutch
//
//  Created by 계은성 on 4/22/24.
//

import UIKit
import SnapKit

// MARK: - ChromaBrightnessSlider

final class ChromaBrightnessSlider: UIControl, ChromaControlStylable {
    
    // MARK: - 레이아웃
    private let handle = SliderHandleView()
    private let sliderTrackView = SliderTrackView()
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    /// The value of the slider between [0.0, 1.0].
    var currentValue: CGFloat = 0.0 {
        didSet { self.updateControl(to: self.currentValue) }
    }
    
    /// The base color the slider on the track.
    var trackColor: UIColor = .white {
        didSet { self.updateTrackColor(to: self.trackColor) }
    }
    
    /// The value of the color the handle is currently displaying.
    var currentColor: UIColor {
        return self.handle.handleColor
    }
    
    var borderWidth: CGFloat = 4.0 {
        didSet { self.layoutNow() }
    }
    
    var borderColor: UIColor = .white {
        didSet { self.layoutNow() }
    }
    
    var showsShadow: Bool = true {
        didSet { self.layoutNow() }
    }
    
    
    /// The amount of padding caused by visual stylings
    private var horizontalPadding: CGFloat {
        return self.sliderTrackView.layer.cornerRadius / 2.0
    }
    
    private var confiningTrackFrame: CGRect {
        return self.sliderTrackView.frame.insetBy(dx: self.horizontalPadding, dy: 0)
    }
    
    private var interactableBounds: CGRect {
        let horizontalOffset = -(self.handle.bounds.width / 2) + self.horizontalPadding
        return bounds.insetBy(dx: horizontalOffset, dy: 0)
    }
    
    
    
    
    
    
    
    
    
    //MARK: - 라이프사이클
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
        self.sliderTrackView.layer.cornerRadius = self.sliderTrackView.bounds.height / 2.0
        self.sliderTrackView.layer.borderColor = self.borderColor.cgColor
        self.sliderTrackView.layer.borderWidth = self.borderWidth
        
        self.moveHandle(to: self.currentValue)
        self.updateShadowIfNeeded()
    }
    // MARK: - 그림자 그리기
    func updateShadowIfNeeded() {
        let views = [self.handle, self.sliderTrackView]
        
        if self.showsShadow {
            let shadowProps = self.shadowProperties(forHeight: bounds.height)
            views.forEach { $0.applyDropShadow(shadowProps) }
        } else {
            views.forEach { $0.removeDropShadow() }
        }
    }
}










// MARK: - 화면 설정
extension ChromaBrightnessSlider {
    private func setupView() {
        self.backgroundColor = .clear
        self.setupSliderTrackView()
        self.setupSliderHandleView()
        self.updateTrackColor(to: self.trackColor)
    }
    
    // MARK: - 오토레이아웃 설정
    private func setupSliderTrackView() {
        self.sliderTrackView.isUserInteractionEnabled = false
        self.addSubview(self.sliderTrackView)
        self.sliderTrackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - 슬라이더 설정
    private func setupSliderHandleView() {
        self.handle.isUserInteractionEnabled = false
        self.addSubview(self.handle)
    }
    
    // MARK: - 트랙 색상 설정
    private func updateTrackColor(to color: UIColor) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        
        let colorWithMaxBrightness = UIColor(hue: hue, saturation: saturation, brightness: 1, alpha: 1)
        
        self.updateTrackViewGradient(for: colorWithMaxBrightness)
        self.currentValue = 1 - brightness
    }
    
    // MARK: - Gradient 설정
    private func updateTrackViewGradient(for color: UIColor) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.sliderTrackView.gradientValues = (color, .black)
        CATransaction.commit()
    }
}










// MARK: - Control 설정

extension ChromaBrightnessSlider {
    
    // MARK: - 시작
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let shouldBeginTracking = self.interactableBounds.contains(location)
        if shouldBeginTracking {
            self.sendActions(for: .touchDown)
        }
        return shouldBeginTracking
    }
    
    // MARK: - 도중
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let clampedPositionX: CGFloat = max(0, min(location.x, self.confiningTrackFrame.width))
        let value = clampedPositionX / self.confiningTrackFrame.width
        
        self.currentValue = value
        self.sendActions(for: .valueChanged)
        return true
    }
    // MARK: - 끝
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.sendActions(for: .touchUpInside)
    }
    
    // MARK: - 포인터 위치 판단
    /// 지정된 포인트가 현재 뷰의 경계 내에 있는지 판단
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // 터치 포인트가 상호 작용 가능한 경계 내에 있는지 확인
        if self.interactableBounds.contains(point) {
            // 있다면 -> 이 뷰에서 이벤트 처리
            return true
        }
        // 없다면 -> 상위 클래스 호출 -> 다른 ㄴ뷰에서 처리할지 결정
        return super.point(inside: point, with: event)
    }
}










// MARK: - 액션

extension ChromaBrightnessSlider {
    
    // MARK: - 컬러 피커 연결
    /// Attaches control to the provided color picker.
    func connect(to colorPicker: ChromaColorPicker) {
        colorPicker.connect(self)
    }
    
    // MARK: - 슬라이더의 색상 판단
    /// Returns the relative value on the slider [0.0, 1.0] for the given color brightness ([0.0, 1.0]).
    func value(brightness: CGFloat) -> CGFloat {
        let clamedBrightness = max(0, min(brightness, 1.0))
        return 1.0 - clamedBrightness
    }
    
    
    
    
    
    // MARK: - 핸들(컨트롤) 액션
    private func updateControl(to value: CGFloat) {
        let brightness = 1 - max(0, min(1, value))
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        self.trackColor.getHue(&hue, saturation: &saturation, brightness: nil, alpha: nil)
        
        let newColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.handle.handleColor = newColor
        CATransaction.commit()
        
        self.moveHandle(to: value)
    }
    
    // MARK: - 핸들 변경 시
    private func moveHandle(to value: CGFloat) {
        let clampedValue = max(0, min(1, value))
        let xPos = (clampedValue * self.confiningTrackFrame.width) + self.horizontalPadding
        let size = CGSize(width: bounds.height * 1.15, height: bounds.height)
        
        self.handle.frame = CGRect(origin: CGPoint(x: xPos - (size.width / 2), y: 0), size: size)
    }
}
