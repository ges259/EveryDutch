//
//  CommonEditScreenType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation

// MARK: - 공통 함수
extension EditScreenType {
    
    // MARK: - 바텀 버튼 타이틀
    func bottomBtnTitle(isMake: Bool) -> String? {
        return isMake
        ? "수정 완료"
        : "생성 완료"
    }
    
    // MARK: - 데코 관련 코드
    var cardHeaderTitle: String {
        return "카드 효과 설정"
    }
    var imageHeaderTitle: String {
        return "이미지 설정"
    }
}









































import UIKit

// MARK: - Extension
extension UIColor {
    
    /// Returns a color with the specified brightness component.
    func withBrightness(_ value: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var alpha: CGFloat = 0
        let brightness = max(0, min(value, 1))
        getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    /// The value of the brightness component.
    var brightness: CGFloat {
        var brightness: CGFloat = 0
        getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }
    
    /// The value of lightness a color has. Value between [0.0, 1.0]
    /// Based on YIQ color space for constrast (https://www.w3.org/WAI/ER/WD-AERT/#color-contrast)
    var lightness: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)

        return ((red * 299) + (green * 587) + (blue * 114)) / 1000
    }
    
    /// Whether or not the color is considered 'light' in terms of contrast.
    var isLight: Bool {
        return lightness >= 0.5
    }
}

extension UIView {
    
    var dropShadowProperties: ShadowProperties? {
        guard let shadowColor = layer.shadowColor else { return nil }
        return ShadowProperties(color: shadowColor, opacity: layer.shadowOpacity, offset: layer.shadowOffset, radius: layer.shadowRadius)
    }
    
    func applyDropShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func applyDropShadow(_ properties: ShadowProperties) {
        applyDropShadow(color: UIColor(cgColor: properties.color), opacity: properties.opacity, offset: properties.offset, radius: properties.radius)
    }
    
    func removeDropShadow() {
        layer.shadowColor = nil
        layer.shadowOpacity = 0
    }
    
    /// Forces the view to layout synchronously and immediately
    func layoutNow() {
        setNeedsLayout()
        layoutIfNeeded()
    }
}




// MARK: - Struct
struct ShadowProperties {
    internal let color: CGColor
    internal let opacity: Float
    internal let offset: CGSize
    internal let radius: CGFloat
}






// MARK: - ChromaColorHandle
final class ChromaColorHandle: UIView, ChromaControlStylable {
    
    /// Current selected color of the handle.
    public var color: UIColor = .black {
        didSet { layoutNow() }
    }
    
    /// An image to display in the handle. Updates `accessoryView` to be a UIImageView.
    public var accessoryImage: UIImage? {
        didSet {
            let imageView = UIImageView(image: accessoryImage)
            imageView.contentMode = .scaleAspectFit
            accessoryView = imageView
        }
    }
    
    /// A view to display in the handle. Overrides any previously set `accessoryImage`.
    public var accessoryView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let accessoryView = accessoryView {
                addAccessoryView(accessoryView)
            }
        }
    }
    
    /// The amount an accessory view's frame should be inset by.
    public var accessoryViewEdgeInsets: UIEdgeInsets = .zero {
        didSet { layoutNow() }
    }
    
    public var borderWidth: CGFloat = 3.0 {
        didSet { layoutNow() }
    }
    
    public var borderColor: UIColor = .white {
        didSet { layoutNow() }
    }
    
    public var showsShadow: Bool = true {
        didSet { layoutNow() }
    }
    
    // MARK: - Initialization
    
    public convenience init(color: UIColor) {
        self.init(frame: .zero)
        self.color = color
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutHandleShape()
        layoutAccessoryViewIfNeeded()
        updateShadowIfNeeded()
        
        layer.masksToBounds = false
    }
    
    // MARK: - Private
    internal let handleShape = CAShapeLayer()
    
    internal func commonInit() {
        layer.addSublayer(handleShape)
    }
    
    internal func updateShadowIfNeeded() {
        if showsShadow {
            let shadowProps = ShadowProperties(color: UIColor.black.cgColor,
                                               opacity: 0.3,
                                               offset: CGSize(width: 0, height: bounds.height / 8.0),
                                               radius: 4.0)
            applyDropShadow(shadowProps)
        } else {
            removeDropShadow()
        }
    }
    
    internal func makeHandlePath(frame: CGRect) -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.minX + 0.5 * frame.width, y: frame.minY + 1 * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX + 1 * frame.width, y: frame.minY + 0.40310 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.83333 * frame.width, y: frame.minY + 0.80216 * frame.height), controlPoint2: CGPoint(x: frame.minX + 1 * frame.width, y: frame.minY + 0.60320 * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX + 0.5 * frame.width, y: frame.minY * frame.height), controlPoint1: CGPoint(x: frame.minX + 1 * frame.width, y: frame.minY + 0.18047 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.77614 * frame.width, y: frame.minY * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX * frame.width, y: frame.minY + 0.40310 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.22386 * frame.width, y: frame.minY * frame.height), controlPoint2: CGPoint(x: frame.minX * frame.width, y: frame.minY + 0.18047 * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 1 * frame.height), controlPoint1: CGPoint(x: frame.minX * frame.width, y: frame.minY + 0.60837 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.16667 * frame.width, y: frame.minY + 0.80733 * frame.height))
        path.close()
        return path.cgPath
    }
    
    internal func layoutHandleShape() {
        let size = CGSize(width: bounds.width - borderWidth, height: bounds.height - borderWidth)
        handleShape.path = makeHandlePath(frame: CGRect(origin: .zero, size: size))
        handleShape.frame = CGRect(origin: CGPoint(x: bounds.midX - (size.width / 2), y: bounds.midY - (size.height / 2)), size: size)
        
        handleShape.fillColor = color.cgColor
        handleShape.strokeColor = borderColor.cgColor
        handleShape.lineWidth = borderWidth
    }
    
    internal func layoutAccessoryViewIfNeeded() {
        if let accessoryLayer = accessoryView?.layer {
            let width = bounds.width - borderWidth * 2
            let size = CGSize(width: width - (accessoryViewEdgeInsets.left + accessoryViewEdgeInsets.right),
                              height: width - (accessoryViewEdgeInsets.top + accessoryViewEdgeInsets.bottom))
            accessoryLayer.frame = CGRect(origin: CGPoint(x: (borderWidth / 2) + accessoryViewEdgeInsets.left, y: (borderWidth / 2) + accessoryViewEdgeInsets.top), size: size)
            
            accessoryLayer.cornerRadius = size.height / 2
            accessoryLayer.masksToBounds = true
        }
    }
    
    internal func addAccessoryView(_ view: UIView) {
        let accessoryLayer = view.layer
        handleShape.addSublayer(accessoryLayer)
    }
}


// MARK: - SliderHandleView
final class SliderHandleView: UIView {

    public var handleColor: UIColor = .black {
        didSet { updateHandleColor(to: handleColor) }
    }
    
    public var borderWidth: CGFloat = 3.0 {
        didSet { layoutNow() }
    }
    
    public var borderColor: UIColor = .white {
        didSet { layoutNow() }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func layoutSubviews() {
        let radius: CGFloat = bounds.height / 10
        handleLayer.path = makeRoundedTrianglePath(width: bounds.width, height: bounds.height, radius: radius)
        handleLayer.strokeColor = borderColor.cgColor
        handleLayer.lineWidth = borderWidth
        handleLayer.position = CGPoint(x: bounds.width / 2, y: (bounds.height / 2.0) - (radius / 4.0))
    }
    
    // MARK: - Private
    private let handleLayer = CAShapeLayer()
    
    private func commonInit() {
        layer.addSublayer(handleLayer)
        updateHandleColor(to: handleColor)
    }
    
    private func updateHandleColor(to color: UIColor) {
        handleLayer.fillColor = color.cgColor
    }
    
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
// MARK: - SliderTrackView
final class SliderTrackView: UIView {
    typealias GradientValues = (start: UIColor, end: UIColor)
    
    var gradientValues: GradientValues = (.white, .black) {
        didSet { updateGradient(for: gradientValues) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = layer.bounds
        gradient.cornerRadius = layer.cornerRadius
    }
    
    func updateGradient(for values: GradientValues) {
        gradient.colors = [values.start.cgColor, values.end.cgColor]
    }
    
    // MARK: - Private
    private let gradient = CAGradientLayer()
    
    private func commonInit() {
        gradient.masksToBounds = true
        gradient.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        updateGradient(for: gradientValues)
        layer.addSublayer(gradient)
    }
}




// MARK: - ChromaBrightnessSlider
final class ChromaBrightnessSlider: UIControl, ChromaControlStylable {
    
    /// The value of the slider between [0.0, 1.0].
    public var currentValue: CGFloat = 0.0 {
        didSet { updateControl(to: currentValue) }
    }
    
    /// The base color the slider on the track.
    public var trackColor: UIColor = .white {
        didSet { updateTrackColor(to: trackColor) }
    }
    
    /// The value of the color the handle is currently displaying.
    public var currentColor: UIColor {
        return handle.handleColor
    }
    
    /// The handle control of the slider.
    public let handle = SliderHandleView()
    
    public var borderWidth: CGFloat = 4.0 {
        didSet { layoutNow() }
    }
    
    public var borderColor: UIColor = .white {
        didSet { layoutNow() }
    }
    
    public var showsShadow: Bool = true {
        didSet { layoutNow() }
    }
    
    //MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        sliderTrackView.layer.cornerRadius = sliderTrackView.bounds.height / 2.0
        sliderTrackView.layer.borderColor = borderColor.cgColor
        sliderTrackView.layer.borderWidth = borderWidth
        
        moveHandle(to: currentValue)
        updateShadowIfNeeded()
    }
    
    // MARK: - Public
    
    /// Attaches control to the provided color picker.
    public func connect(to colorPicker: ChromaColorPicker) {
        colorPicker.connect(self)
    }
    
    /// Returns the relative value on the slider [0.0, 1.0] for the given color brightness ([0.0, 1.0]).
    public func value(brightness: CGFloat) -> CGFloat {
        let clamedBrightness = max(0, min(brightness, 1.0))
        return 1.0 - clamedBrightness
    }
    
    // MARK: - Control
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let shouldBeginTracking = interactableBounds.contains(location)
        if shouldBeginTracking {
            sendActions(for: .touchDown)
        }
        return shouldBeginTracking
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let clampedPositionX: CGFloat = max(0, min(location.x, confiningTrackFrame.width))
        let value = clampedPositionX / confiningTrackFrame.width
        
        currentValue = value
        sendActions(for: .valueChanged)
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        sendActions(for: .touchUpInside)
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if interactableBounds.contains(point) {
            return true
        }
        return super.point(inside: point, with: event)
    }
    
    internal func updateShadowIfNeeded() {
        let views = [handle, sliderTrackView]
        
        if showsShadow {
            let shadowProps = shadowProperties(forHeight: bounds.height)
            views.forEach { $0.applyDropShadow(shadowProps) }
        } else {
            views.forEach { $0.removeDropShadow() }
        }
    }
    
    // MARK: - Private
    private let sliderTrackView = SliderTrackView()
    
    /// The amount of padding caused by visual stylings
    private var horizontalPadding: CGFloat {
        return sliderTrackView.layer.cornerRadius / 2.0
    }
    
    private var confiningTrackFrame: CGRect {
        return sliderTrackView.frame.insetBy(dx: horizontalPadding, dy: 0)
    }
    
    private var interactableBounds: CGRect {
        let horizontalOffset = -(handle.bounds.width / 2) + horizontalPadding
        return bounds.insetBy(dx: horizontalOffset, dy: 0)
    }
    
    private func commonInit() {
        backgroundColor = .clear
        setupSliderTrackView()
        setupSliderHandleView()
        updateTrackColor(to: trackColor)
    }
    
    private func setupSliderTrackView() {
        sliderTrackView.isUserInteractionEnabled = false
        sliderTrackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sliderTrackView)
        NSLayoutConstraint.activate([
            sliderTrackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sliderTrackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sliderTrackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            sliderTrackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func setupSliderHandleView() {
        handle.isUserInteractionEnabled = false
        addSubview(handle)
    }
    
    private func updateControl(to value: CGFloat) {
        let brightness = 1 - max(0, min(1, value))
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        trackColor.getHue(&hue, saturation: &saturation, brightness: nil, alpha: nil)
        
        let newColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        handle.handleColor = newColor
        CATransaction.commit()
        
        moveHandle(to: value)
    }
    
    private func updateTrackColor(to color: UIColor) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        
        let colorWithMaxBrightness = UIColor(hue: hue, saturation: saturation, brightness: 1, alpha: 1)
        
        updateTrackViewGradient(for: colorWithMaxBrightness)
        currentValue = 1 - brightness
    }
    
    private func updateTrackViewGradient(for color: UIColor) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        sliderTrackView.gradientValues = (color, .black)
        CATransaction.commit()
    }
    
    private func moveHandle(to value: CGFloat) {
        let clampedValue = max(0, min(1, value))
        let xPos = (clampedValue * confiningTrackFrame.width) + horizontalPadding
        let size = CGSize(width: bounds.height * 1.15, height: bounds.height)
        
        handle.frame = CGRect(origin: CGPoint(x: xPos - (size.width / 2), y: 0), size: size)
    }
}

















// MARK: - Protocol
protocol ChromaControlStylable {
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor { get set }
    var showsShadow: Bool { get set }
    
    func updateShadowIfNeeded()
}

extension ChromaControlStylable where Self: UIView {
    
    func shadowProperties(forHeight height: CGFloat) -> ShadowProperties {
        let dropShadowHeight = height * 0.01
        return ShadowProperties(color: UIColor.black.cgColor, opacity: 0.35, offset: CGSize(width: 0, height: dropShadowHeight), radius: 4)
    }
}
// MARK: - Delegate
protocol ChromaColorPickerDelegate: AnyObject {
    /// When a handle's value has changed.
    func colorPickerHandleDidChange(_ colorPicker: ChromaColorPicker, handle: ChromaColorHandle, to color: UIColor)
}


// MARK: - ChromaColorPicker
final class ChromaColorPicker: UIControl, ChromaControlStylable {
    
    public weak var delegate: ChromaColorPickerDelegate?
    
    @IBInspectable public var borderWidth: CGFloat = 6.0 {
        didSet { layoutNow() }
    }
    
    @IBInspectable public var borderColor: UIColor = .white {
        didSet { layoutNow() }
    }
    
    @IBInspectable public var showsShadow: Bool = true {
        didSet { layoutNow() }
    }
    
    /// A brightness slider attached via the `connect(_:)` method.
    private(set) public weak var brightnessSlider: ChromaBrightnessSlider? {
        didSet {
            oldValue?.removeTarget(self, action: nil, for: .valueChanged)
        }
    }
    
    /// The size handles should be displayed at.
    public var handleSize: CGSize = defaultHandleSize {
        didSet { setNeedsLayout() }
    }
    
    /// An extension to handles' hitboxes in the +Y direction.
    /// Allows for handles to be grabbed more easily.
    public var handleHitboxExtensionY: CGFloat = 10.0
    
    /// Handles added to the color picker.
    private(set) public var handles: [ChromaColorHandle] = []
    
    /// The last active handle.
    private(set) public var currentHandle: ChromaColorHandle?
    
    //MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowIfNeeded()
        updateBorderIfNeeded()
        
        handles.forEach { handle in
            let location = colorWheelView.location(of: handle.color)
            handle.frame.size = handleSize
            positionHandle(handle, forColorLocation: location)
        }
    }
    
    // MARK: - Public
    
    @discardableResult
    public func addHandle(at color: UIColor? = nil) -> ChromaColorHandle {
        let handle = ChromaColorHandle()
        handle.color = color ?? defaultHandleColorPosition
        addHandle(handle)
        return handle
    }
    
    public func addHandle(_ handle: ChromaColorHandle) {
        handles.append(handle)
        colorWheelView.addSubview(handle)
        brightnessSlider?.trackColor = handle.color
        
        if currentHandle == nil {
            currentHandle = handle
        }
    }
    
    public func connect(_ slider: ChromaBrightnessSlider) {
        slider.addTarget(self, action: #selector(brightnessSliderDidValueChange(_:)), for: .valueChanged)
        brightnessSlider = slider
    }
    
    // MARK: - Control
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: colorWheelView)
        
        for handle in handles {
            if extendedHitFrame(for: handle).contains(location) {
                colorWheelView.bringSubviewToFront(handle)
                animateHandleScale(handle, shouldGrow: true)
                
                if let slider = brightnessSlider {
                    slider.trackColor = handle.color.withBrightness(1)
                    slider.currentValue = slider.value(brightness: handle.color.brightness)
                }
                
                currentHandle = handle
                return true
            }
        }
        return false
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var location = touch.location(in: colorWheelView)
        guard let handle = currentHandle else { return false }
        
        if !colorWheelView.pointIsInColorWheel(location) {
            // Touch is outside color wheel and should map to outermost edge.
            let center = colorWheelView.middlePoint
            let radius = colorWheelView.radius
            let angleToCenter = atan2(location.x - center.x, location.y - center.y)
            let positionOnColorWheelEdge = CGPoint(x: center.x + radius * sin(angleToCenter),
                                                   y: center.y + radius * cos(angleToCenter))
            location = positionOnColorWheelEdge
        }
        
        if let pixelColor = colorWheelView.pixelColor(at: location) {
            let previousBrightness = handle.color.brightness
            handle.color = pixelColor.withBrightness(previousBrightness)
            positionHandle(handle, forColorLocation: location)
            
            if let slider = brightnessSlider {
                slider.trackColor = pixelColor
                slider.currentValue = slider.value(brightness: previousBrightness)
            }
            
            informDelegateOfColorChange(on: handle)
            sendActions(for: .valueChanged)
        }
        
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if let handle = currentHandle {
            animateHandleScale(handle, shouldGrow: false)
        }
        sendActions(for: .touchUpInside)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Self should handle all touch events, forwarding if needed.
        let touchableBounds = bounds.insetBy(dx: -handleSize.width, dy: -handleSize.height)
        return touchableBounds.contains(point) ? self : super.hitTest(point, with: event)
    }

    // MARK: - Private
    
    internal let colorWheelView = ColorWheelView()
    internal var colorWheelViewWidthConstraint: NSLayoutConstraint!
    
    internal func commonInit() {
        self.backgroundColor = UIColor.clear
        setupColorWheelView()
    }
    
    internal func setupColorWheelView() {
        colorWheelView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorWheelView)
        colorWheelViewWidthConstraint = colorWheelView.widthAnchor.constraint(equalTo: self.widthAnchor)
        
        NSLayoutConstraint.activate([
            colorWheelView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            colorWheelView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            colorWheelViewWidthConstraint,
            colorWheelView.heightAnchor.constraint(equalTo: colorWheelView.widthAnchor),
        ])
    }
    
    func updateShadowIfNeeded() {
        if showsShadow {
            applyDropShadow(shadowProperties(forHeight: bounds.height))
        } else {
            removeDropShadow()
        }
    }
    
    internal func updateBorderIfNeeded() {
        // Use view's background as a border so colorWheel subviews (handles)
        // may appear above the border.
        backgroundColor = borderWidth > 0 ? borderColor : .clear
        layer.cornerRadius = bounds.height / 2.0
        layer.masksToBounds = false
        colorWheelViewWidthConstraint.constant = -borderWidth * 2.0
    }
    
    // MARK: Actions

    @objc
    internal func brightnessSliderDidValueChange(_ slider: ChromaBrightnessSlider) {
        guard let currentHandle = currentHandle else { return }
        
        currentHandle.color = slider.currentColor
        informDelegateOfColorChange(on: currentHandle)
    }
    
    internal func informDelegateOfColorChange(on handle: ChromaColorHandle) { // TEMP:
        delegate?.colorPickerHandleDidChange(self, handle: handle, to: handle.color)
    }
    
    // MARK: - Helpers
    
    internal func extendedHitFrame(for handle: ChromaColorHandle) -> CGRect {
        var frame = handle.frame
        frame.size.height += handleHitboxExtensionY
        return frame
    }
    
    internal func positionHandle(_ handle: ChromaColorHandle, forColorLocation location: CGPoint) {
        handle.center = location.applying(CGAffineTransform.identity.translatedBy(x: 0, y: -handle.bounds.height / 2))
    }
    
    internal func animateHandleScale(_ handle: ChromaColorHandle, shouldGrow: Bool) {
        if shouldGrow && handle.transform.d > 1 { return } // Already grown
        let scalar: CGFloat = 1.25
        
        var transform: CGAffineTransform = .identity
        if shouldGrow {
            let translateY = -handle.bounds.height * (scalar - 1) / 2
            transform = CGAffineTransform(scaleX: scalar, y: scalar).translatedBy(x: 0, y: translateY)
        }
        
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            handle.transform = transform
        }, completion: nil)
    }
}

internal let defaultHandleColorPosition: UIColor = .white
internal let defaultHandleSize: CGSize = CGSize(width: 42, height: 52)






/// This value is used to expand the imageView's bounds and then mask back to its normal size
/// such that any displayed image may have perfectly rounded corners.
private let defaultImageViewCurveInset: CGFloat = 1.0
// MARK: - ColorWheelView
final class ColorWheelView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = false
        layer.cornerRadius = radius
        // MARK: - Fix
        if let colorWheelCIImage = makeColorWheelImage(radius: radius * UIScreen.main.scale) {
            let context = CIContext(options: nil)
            if let colorWheelCGImage = context.createCGImage(colorWheelCIImage, from: colorWheelCIImage.extent) {
                let colorWheelUIImage = UIImage(cgImage: colorWheelCGImage)
                imageView.image = colorWheelUIImage
            }
        }
        // Mask imageview so the generated colorwheel has smooth edges.
        // We mask the imageview instead of image so we get the benefits of using the CIImage
        // rendering directly on the GPU.
        imageViewMask.frame = imageView.bounds.insetBy(dx: defaultImageViewCurveInset, dy: defaultImageViewCurveInset)
        imageViewMask.layer.cornerRadius = imageViewMask.bounds.width / 2.0
        imageView.mask = imageViewMask
    }

    public var radius: CGFloat {
        return max(bounds.width, bounds.height) / 2.0
    }
    
    public var middlePoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /**
     Returns the (x,y) location of the color provided within the ColorWheelView.
     Disregards color's brightness component.
    */
    public func location(of color: UIColor) -> CGPoint {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: nil, alpha: nil)
        
        let radianAngle = hue * (2 * .pi)
        let distance = saturation * radius
        let colorTranslation = CGPoint(x: distance * cos(radianAngle), y: -distance * sin(radianAngle))
        let colorPoint = CGPoint(x: bounds.midX + colorTranslation.x, y: bounds.midY + colorTranslation.y)
        
        return colorPoint
    }
    
    /**
     Returns the color on the wheel on a given point relative to the view. nil is returned if
     the point does not exist within the bounds of the color wheel.
    */
    // TODO: replace this function with a mathmatically based one in ChromaColorPicker
    public func pixelColor(at point: CGPoint) -> UIColor? {
        guard pointIsInColorWheel(point) else { return nil }
        
        // Values on the edge of the circle should be calculated instead of obtained
        // from the rendered view layer. This ensures we obtain correct values where
        // image smoothing may have taken place.
        guard !pointIsOnColorWheelEdge(point) else {
            let angleToCenter = atan2(point.x - middlePoint.x, point.y - middlePoint.y)
            return edgeColor(for: angleToCenter)
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
        imageView.layer.render(in: context)
        let color = UIColor(
            red: CGFloat(pixel[0]) / 255.0,
            green: CGFloat(pixel[1]) / 255.0,
            blue: CGFloat(pixel[2]) / 255.0,
            alpha: 1.0
        )
        
        pixel.deallocate()
        return color
    }
    
    /**
     Returns whether or not the point is in the circular area of the color wheel.
    */
    public func pointIsInColorWheel(_ point: CGPoint) -> Bool {
        guard bounds.insetBy(dx: -1, dy: -1).contains(point) else { return false }
        
        let distanceFromCenter: CGFloat = hypot(middlePoint.x - point.x, middlePoint.y - point.y)
        let pointExistsInRadius: Bool = distanceFromCenter <= (radius - layer.borderWidth)
        return pointExistsInRadius
    }
    
    public func pointIsOnColorWheelEdge(_ point: CGPoint) -> Bool {
        let distanceToCenter = hypot(middlePoint.x - point.x, middlePoint.y - point.y)
        let isPointOnEdge = distanceToCenter >= radius - 1.0
        return isPointOnEdge
    }
    
    // MARK: - Private
    internal let imageView = UIImageView()
    internal let imageViewMask = UIView()
    
    internal func commonInit() {
        backgroundColor = .clear
        setupImageView()
    }
    
    internal func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageViewMask.backgroundColor = .black
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: defaultImageViewCurveInset * 2),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, constant: defaultImageViewCurveInset * 2),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    /**
     Generates a color wheel image from a given radius.
     - Parameters:
        - radius: The radius of the wheel in points. A radius of 100 would generate an
                  image of 200x200 points (400x400 pixels on a device with 2x scaling.)
    */
    internal func makeColorWheelImage(radius: CGFloat) -> CIImage? {
        let filter = CIFilter(name: "CIHueSaturationValueGradient", parameters: [
            "inputColorSpace": CGColorSpaceCreateDeviceRGB(),
            "inputDither": 0,
            "inputRadius": radius,
            "inputSoftness": 0,
            "inputValue": 1
        ])
        
        // 여기서는 CIImage를 직접 리턴합니다.
        return filter?.outputImage?.cropped(to: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
    }
    /**
     Returns a color for a provided radian angle on the color wheel.
     - Note: Adjusts angle for the local color space and returns a color of
             max saturation and brightness with variable hue.
    */
    internal func edgeColor(for angle: CGFloat) -> UIColor {
        var normalizedAngle = angle + .pi // normalize to [0, 2pi]
        normalizedAngle += (.pi / 2) // rotate pi/2 for color wheel
        var hue = normalizedAngle / (2 * .pi)
        if hue > 1 { hue -= 1 }
        return UIColor(hue: hue, saturation: 1, brightness: 1.0, alpha: 1.0)
    }
}














