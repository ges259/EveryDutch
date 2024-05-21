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
    /// 상단 툴바
    private lazy var toolbar: ToolbarStackView = {
        let toolbar = ToolbarStackView()
            toolbar.delegate = self
        return toolbar
    }()
    /// 색상 팔레트
    private lazy var colorPicker = {
        let picker = ChromaColorPicker()
            picker.delegate = self
        // 컬러피커에 슬라이더 및 핸들 연결
        picker.connect(self.brightnessSlider)
        picker.addHandle(self.homeHandle)
        return picker
    }()
    private var pickerStackViewWidthConstraint: Constraint!
    
    /// 하단 슬라이드
    private let brightnessSlider = ChromaBrightnessSlider()
    /// 팔레트 위에 핸들
    private lazy var homeHandle: ChromaColorHandle = ChromaColorHandle(color: .medium_Blue)
    
    
    
    
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
    
    
    
    
    
    // MARK: - 화면 설정
    private func setupView() {
        self.backgroundColor = .medium_Blue
        self.clipsToBounds = true
        
        self.addShadow(shadowType: .top)
        
        self.setRoundedCorners(.top, withCornerRadius: 12)
    }
    
    // MARK: - 오토레이아웃 설정
    private func setupAutoLayout() {
        self.addSubview(self.colorPicker)
        self.addSubview(self.brightnessSlider)
        self.addSubview(self.toolbar)
        // 상단 툴바
        self.toolbar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        // 하단 슬라이더
        self.brightnessSlider.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-45)
            make.height.equalTo(40)
            make.width.equalTo(UIScreen.main.bounds.width - 90)
            make.centerX.equalToSuperview()
        }
        // 색상 팔레트
        self.colorPicker.snp.makeConstraints { make in
            make.top.equalTo(self.toolbar.snp.bottom).offset(20)
            make.bottom.greaterThanOrEqualTo(self.brightnessSlider.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            self.pickerStackViewWidthConstraint = make.width.greaterThanOrEqualTo(0).constraint
        }
    }
    
    // MARK: - 높이 재설정
    /// open상태일 때, customColorPicker의 높이를 재설정하는 함수
    func updateConstraintsForExpandedState(isExpanded: Bool) {
        // open(isExpanded) 이라면,
        if isExpanded {
            // 현재 높이 가져오기
            let currentHeight = self.colorPicker.frame.height
            // 높이가 서로 다르다면,
            if self.colorPicker.frame.width != currentHeight {
                // constraint 비활성화
                self.pickerStackViewWidthConstraint?.deactivate()
                // constraint 다시 설정
                self.colorPicker.snp.makeConstraints { make in
                    self.pickerStackViewWidthConstraint = make.width.equalTo(currentHeight).constraint
                }
                self.layoutIfNeeded()
            }
        }
    }
}









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
