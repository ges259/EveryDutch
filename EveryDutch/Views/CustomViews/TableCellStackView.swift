//
//  TableCellStackView.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit
import SnapKit

final class TableCellStackView: UIStackView {
    
    // MARK: - 레이아웃
    var profileImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.black
        return img
    }()
    
    var userNameLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 14))
    
    lazy var priceLbl: CustomLabel = CustomLabel(
        backgroundColor: .medium_Blue,
        topBottomInset: 4,
        leftInset: 10,
        rightInset: 10)
    
    
    lazy var rightImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.black
        return img
    }()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var priceLblInStackView: Bool = true
    private var rightImgInStackView: Bool = false
    
    // MARK: - 라이프사이클
    init(priceLblInStackView: Bool = true,
         rightImgInStackView: Bool) {
        self.priceLblInStackView = priceLblInStackView
        self.rightImgInStackView = rightImgInStackView
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configurePriceLabel()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension TableCellStackView {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.spacing = 7
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fill
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.profileImg,
         self.userNameLbl].forEach { view in
            self.addArrangedSubview(view)
        }
        self.profileImg.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
        
        if self.priceLblInStackView {
            self.configurePriceLabel()
        }
        if self.rightImgInStackView {
            self.configureRightImage()
        }
    }
    
    private func configureRightImage() {
        self.addArrangedSubview(self.rightImg)
        self.rightImg.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
    }
    
    private func configurePriceLabel() {
        self.addArrangedSubview(self.priceLbl)
        // 허깅 설정
        self.priceLbl.setContentHuggingPriority(
            UILayoutPriority.defaultHigh,
            for: .horizontal)
        
        self.priceLbl.clipsToBounds = true
        self.priceLbl.layer.cornerRadius = 10
    }
}
