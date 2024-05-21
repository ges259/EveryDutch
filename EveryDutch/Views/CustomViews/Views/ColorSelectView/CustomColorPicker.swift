//
//  CustomColorPicker.swift
//  EveryDutch
//
//  Created by 계은성 on 4/22/24.
//

import UIKit
import SnapKit

final class CustomColorPicker: UIView {
    
    // MARK: - 레이아웃
    private lazy var toolbar: ToolbarStackView = {
        let toolbar = ToolbarStackView()
            toolbar.delegate = self
        return toolbar
    }()
    
    private lazy var colorPicker = {
        let picker = ChromaColorPicker()
            picker.delegate = self
        return picker
    }()
    private let brightnessSlider = ChromaBrightnessSlider()
    
    private lazy var homeHandle: ChromaColorHandle = {
        let handle = ChromaColorHandle(color: .blue)
            handle.accessoryView = imageView
            handle.accessoryViewEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 4, right: 4)
        return handle
    }()
    
    private let imageView: UIImageView = {
        let img = UIImageView(image: UIImage.Exit_Img)
            img.contentMode = .scaleAspectFit
            img.tintColor = .white
        return img
    }()
    
    
    // MARK: - 프로퍼티
    weak var delegate: CustomPickerDelegate?
    
    private var currentColor: UIColor?
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupView()
        self.setupAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
//    
//    
//    
//    private lazy var pickerStackView: UIStackView = UIStackView.configureStv(
//        arrangedSubviews: [self.colorPicker,
//                           self.brightnessSlider],
//        axis: .vertical,
//        spacing: 20,
//        alignment: .center,
//        distribution: .fill)
//    
    
    
    // MARK: - 화면 설정
    private func setupView() {
        self.backgroundColor = .medium_Blue
        self.clipsToBounds = true
        
        self.addShadow(shadowType: .top)
        
        self.setRoundedCorners(.top, withCornerRadius: 12)
        
        self.colorPicker.connect(self.brightnessSlider)
        self.colorPicker.addHandle(self.homeHandle)
    }
    
    // MARK: - 오토레이아웃 설정
    private var pickerStackViewWidthConstraint: Constraint!
    

    private func setupAutoLayout() {
        self.addSubview(self.colorPicker)
        self.addSubview(self.brightnessSlider)
        self.addSubview(self.toolbar)
        
        self.toolbar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        self.brightnessSlider.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(40)
            make.width.equalTo(UIScreen.main.bounds.width - 80)
            make.centerX.equalToSuperview()
        }
        self.colorPicker.snp.makeConstraints { make in
            make.top.equalTo(self.toolbar.snp.bottom).offset(10)
            make.bottom.greaterThanOrEqualTo(self.brightnessSlider.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            self.pickerStackViewWidthConstraint = make.width.greaterThanOrEqualTo(0).constraint
            
        }
    }
    
    func updateConstraintsForExpandedState(isExpanded: Bool) {
        if isExpanded {
            self.pickerStackViewWidthConstraint?.deactivate()
            self.colorPicker.snp.makeConstraints { make in
                self.pickerStackViewWidthConstraint =
                make.width.equalTo(self.colorPicker.frame.height).constraint
            }
            self.layoutIfNeeded()
        }
    }
}

/*
 // 마지막 성공 버전
 self.brightnessSlider.snp.makeConstraints { make in
     make.bottom.equalToSuperview().offset(-30)
     make.height.equalTo(40)
     make.width.equalTo(UIScreen.main.bounds.width - 60)
     make.centerX.equalToSuperview()
 }
 self.colorPicker.snp.makeConstraints { make in
     make.top.equalTo(self.toolbar.snp.bottom).offset(10)
     make.bottom.greaterThanOrEqualTo(self.brightnessSlider.snp.top).offset(-10)
     make.centerX.equalToSuperview()
     self.pickerStackViewWidthConstraint = make.width.greaterThanOrEqualTo(0).constraint
 }
 func updateConstraintsForExpandedState(isExpanded: Bool) {
     if isExpanded {
         self.pickerStackViewWidthConstraint?.deactivate()
         self.colorPicker.snp.makeConstraints { make in
             self.pickerStackViewWidthConstraint =
             make.width.equalTo(self.colorPicker.frame.height).constraint
         }
         self.layoutIfNeeded()
     }
 }
 */

/*
 self.brightnessSlider.snp.makeConstraints { make in
     make.bottom.equalToSuperview().offset(-30)
     make.height.equalTo(40)
     make.width.equalTo(UIScreen.main.bounds.width - 60)
     make.centerX.equalToSuperview()
 }
 
 self.colorPicker.snp.makeConstraints { make in
     make.top.equalTo(self.toolbar.snp.bottom).offset(30)
     make.bottom.equalTo(self.brightnessSlider.snp.top).offset(-30)
     make.centerX.equalToSuperview()
     make.width.greaterThanOrEqualTo(UIScreen.main.bounds.width - 60)
     self.customSize = make.height.greaterThanOrEqualTo(self.colorPicker.snp.width).constraint
 */
/*
 
 self.brightnessSlider.snp.makeConstraints { make in
     make.bottom.equalToSuperview().offset(-30)
     make.height.equalTo(40)
     make.leading.trailing.equalToSuperview().inset(30)
 }
 
 self.colorPicker.snp.makeConstraints { make in
     make.top.equalTo(self.toolbar.snp.bottom).offset(30)
     make.bottom.equalTo(self.brightnessSlider.snp.top).offset(-30)
     make.centerX.equalToSuperview()
     make.width.equalTo(self.colorPicker.snp.height)
     make.width.greaterThanOrEqualTo(UIScreen.main.bounds.width - 60)
 }
 */









// MARK: - 컬러 피커 델리게이트
extension CustomColorPicker: CustomColorPickerDelegate {
    func colorPickerHandleDidChange(_ colorPicker: ChromaColorPicker,
                                    handle: ChromaColorHandle,
                                    to color: UIColor) {
        self.currentColor = color
        self.delegate?.changedCropLocation(data: color)
    }
}

// MARK: - 툴바 델리게이트
extension CustomColorPicker: ToolbarDelegate {
    func cancelBtnTapped() {
        self.delegate?.cancel(type: .colorPicker)
    }
    
    func saveBtnTapped() {
        guard let color = self.currentColor else { return }
        self.delegate?.done(with: color)
    }
}
