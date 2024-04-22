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
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupView()
        self.setupAutoLayaout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 화면 설정
    private func setupView() {
        self.backgroundColor = .medium_Blue
    }
    
    // MARK: - 오토레이아웃 설정
    private func setupAutoLayaout() {
        self.addSubview(self.colorPicker)
        self.addSubview(self.brightnessSlider)
        self.colorPicker.connect(self.brightnessSlider)
        self.colorPicker.addHandle(self.homeHandle)
        
        self.colorPicker.snp.makeConstraints { make in
            make.size.equalTo(250)
            make.center.equalToSuperview()
        }
        self.brightnessSlider.snp.makeConstraints { make in
            make.top.equalTo(self.colorPicker.snp.bottom).offset(30)
            make.leading.trailing.equalTo(self.colorPicker)
            make.height.equalTo(50)
        }
    }
}










// MARK: - 컬러 피커 델리게이트
extension CustomColorPicker: ChromaColorPickerDelegate {
    func colorPickerHandleDidChange(_ colorPicker: ChromaColorPicker,
                                    handle: ChromaColorHandle,
                                    to color: UIColor) {
//        print(color)
    }
}

