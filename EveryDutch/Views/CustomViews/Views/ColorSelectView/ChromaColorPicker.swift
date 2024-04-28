//
//  ChromaColorPicker.swift
//  EveryDutch
//
//  Created by 계은성 on 4/22/24.
//

import UIKit
import SnapKit

private let defaultHandleColorPosition: UIColor = .white
private let defaultHandleSize: CGSize = CGSize(width: 42, height: 52)

// MARK: - ChromaColorPicker

final class ChromaColorPicker: UIControl, ChromaControlStylable {
    
    // MARK: - 레이아웃
    private let colorWheelView = ColorWheelView()
    private var colorWheelViewWidthConstraint: Constraint!
    
    /*
     --- private
     private var name: String = "Secret"
     -> 해당 프로퍼티(메서드)는 클래스 또는 구조체 내부에서만 접근이 가능함.
     
     --- private(set)
     private(set) var count: Int = 0
     -> count는 어디서든 읽을 수 있지만, 클래스 내부에서만 수정이 가능함.
     */
    /// Handles added to the color picker.
    private(set) var handles: [ChromaColorHandle] = []
    
    /// The last active handle.
    private(set) var currentHandle: ChromaColorHandle?
    
    private(set) weak var brightnessSlider: ChromaBrightnessSlider? {
        didSet {
            oldValue?.removeTarget(self, action: nil, for: .valueChanged)
        }
    }
    
    
    
    
    
    
    // MARK: - 프로퍼티
    public weak var delegate: CustomColorPickerDelegate?
    
    var borderWidth: CGFloat = 6.0 {
        didSet { self.layoutNow() }
    }
    
    var borderColor: UIColor = .white {
        didSet { self.layoutNow() }
    }
    
    var showsShadow: Bool = true {
        didSet { self.layoutNow() }
    }
    
    /// The size handles should be displayed at.
    var handleSize: CGSize = defaultHandleSize {
        didSet { self.setNeedsLayout() }
    }
    
    /// An extension to handles' hitboxes in the +Y direction.
    /// Allows for handles to be grabbed more easily.
    var handleHitboxExtensionY: CGFloat = 10.0
    

    
    
    
    
    
    
    
    
    //MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupColorWheelView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // 뷰가 서브뷰 레이아웃을 조정할 때 호출
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateShadowIfNeeded()
        self.updateBorderIfNeeded()
        
        self.handles.forEach { handle in
            let location = self.colorWheelView.location(of: handle.color)
            handle.frame.size = self.handleSize
            self.positionHandle(handle, forColorLocation: location)
        }
    }
    // MARK: - 그림자 그리기
    func updateShadowIfNeeded() {
        if self.showsShadow {
            self.applyDropShadow(shadowProperties(forHeight: self.bounds.height))
        } else {
            self.removeDropShadow()
        }
    }
    // MARK: - border 다시 그리기
    private func updateBorderIfNeeded() {
        self.backgroundColor = self.borderWidth > 0 ? self.borderColor : .clear
        self.layer.cornerRadius = self.bounds.height / 2.0
        self.layer.masksToBounds = false
        self.colorWheelViewWidthConstraint.update(offset: -self.borderWidth * 2.0)
    }
}
    
    
    
    
    


    
    
    
// MARK: - 화면 설정
extension ChromaColorPicker {
    private func setupView() {
        self.backgroundColor = UIColor.clear
    }
    
    // MARK: - 오토레이아웃 설정
    private func setupColorWheelView() {
        self.addSubview(self.colorWheelView)
        
        self.colorWheelView.snp.makeConstraints { make in
            self.colorWheelViewWidthConstraint = make.width.equalToSuperview().constraint
            make.height.equalTo(colorWheelView.snp.width)
            make.center.equalToSuperview()
        }
    }
}










// MARK: - Control 설정

extension ChromaColorPicker {
    
    // MARK: - 시작
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self.colorWheelView)
        
        for handle in self.handles {
            if self.extendedHitFrame(for: handle).contains(location) {
                self.colorWheelView.bringSubviewToFront(handle)
                self.animateHandleScale(handle, shouldGrow: true)
                
                if let slider = self.brightnessSlider {
                    slider.trackColor = handle.color.withBrightness(1)
                    slider.currentValue = slider.value(brightness: handle.color.brightness)
                }
                
                self.currentHandle = handle
                return true
            }
        }
        return false
    }
    
    // MARK: - 도중
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var location = touch.location(in: self.colorWheelView)
        guard let handle = self.currentHandle else { return false }
        
        if !self.colorWheelView.pointIsInColorWheel(location) {
            // Touch is outside color wheel and should map to outermost edge.
            let center = self.colorWheelView.middlePoint
            let radius = self.colorWheelView.radius
            let angleToCenter = atan2(location.x - center.x, location.y - center.y)
            let positionOnColorWheelEdge = CGPoint(
                x: center.x + radius * sin(angleToCenter),
                y: center.y + radius * cos(angleToCenter))
            location = positionOnColorWheelEdge
        }
        
        if let pixelColor = self.colorWheelView.pixelColor(at: location) {
            let previousBrightness = handle.color.brightness
            handle.color = pixelColor.withBrightness(previousBrightness)
            self.positionHandle(handle, forColorLocation: location)
            
            // 슬라이더의 색상 및 값 변경
            if let slider = self.brightnessSlider {
                slider.trackColor = pixelColor
                slider.currentValue = slider.value(brightness: previousBrightness)
            }
            
            self.informDelegateOfColorChange(on: handle)
            self.sendActions(for: .valueChanged)
        }
        
        return true
    }
    
    // MARK: - 끝
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if let handle = self.currentHandle {
            self.animateHandleScale(handle, shouldGrow: false)
        }
        self.sendActions(for: .touchUpInside)
    }
    
    // MARK: - 탭
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Self should handle all touch events, forwarding if needed.
        let touchableBounds = self.bounds.insetBy(
            dx: -self.handleSize.width,
            dy: -self.handleSize.height)
        return touchableBounds.contains(point) ? self : super.hitTest(point, with: event)
    }
}
    
    
    

    
    
    
    
    
    
// MARK: - 액션

extension ChromaColorPicker {
    
    // MARK: - 핸들 추가 및 연결
    // @discardableResult - 반환 값을 사용하지 않아도 상관X
    @discardableResult
    func addHandle(at color: UIColor? = nil) -> ChromaColorHandle {
        let handle = ChromaColorHandle()
            handle.color = color ?? defaultHandleColorPosition
        self.addHandle(handle)
        return handle
    }
    /// 핸들을 colorPicker에 연결하는 메서드
    func addHandle(_ handle: ChromaColorHandle) {
        self.handles.append(handle)
        self.colorWheelView.addSubview(handle)
        self.brightnessSlider?.trackColor = handle.color
        
        if self.currentHandle == nil { self.currentHandle = handle }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 슬라이더 연결 및 액션 설정
    /// 슬라이더를 colorPicker에 연결하는 메서드
    /// 슬라이더를 변경할 때마다 호출 됨
    func connect(_ slider: ChromaBrightnessSlider) {
        slider.addTarget(self,
                         action: #selector(self.brightnessSliderDidValueChange(_:)),
                         for: .valueChanged)
        self.brightnessSlider = slider
    }
    
    // MARK: 슬라이더 색상 변경
    @objc private func brightnessSliderDidValueChange(_ slider: ChromaBrightnessSlider) {
        guard let currentHandle = self.currentHandle else { return }
            currentHandle.color = slider.currentColor
        self.informDelegateOfColorChange(on: currentHandle)
    }
    // MARK: 핸들 색상 변경
    private func informDelegateOfColorChange(on handle: ChromaColorHandle) {
        self.delegate?.colorPickerHandleDidChange(self, handle: handle, to: handle.color)
    }
    
    
    
    
    
    // MARK: - 핸들(컨트롤) 액션
    private func extendedHitFrame(for handle: ChromaColorHandle) -> CGRect {
        var frame = handle.frame
        frame.size.height += self.handleHitboxExtensionY
        return frame
    }
    
    private func positionHandle(_ handle: ChromaColorHandle, forColorLocation location: CGPoint) {
        handle.center = location.applying(
            CGAffineTransform
                .identity
                .translatedBy(
                    x: 0,
                    y: -handle.bounds.height / 2))
    }
    
    private func animateHandleScale(_ handle: ChromaColorHandle, shouldGrow: Bool) {
        if shouldGrow && handle.transform.d > 1 { return } // Already grown
        let scalar: CGFloat = 1.25
        
        var transform: CGAffineTransform = .identity
        if shouldGrow {
            let translateY = -handle.bounds.height * (scalar - 1) / 2
            transform = CGAffineTransform(scaleX: scalar, y: scalar).translatedBy(x: 0, y: translateY)
        }
        
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut) {
            handle.transform = transform
        }
    }
}
