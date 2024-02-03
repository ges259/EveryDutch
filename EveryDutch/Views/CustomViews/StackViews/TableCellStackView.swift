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
        text: "0원",
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





























enum CellSelectionUIStvEnum {
    case peopleSelection
    case cardDecoration
}

final class CellSelectionUIStv: UIStackView {
    
    // MARK: - 레이아웃
    lazy var profileImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.black
        return img
    }()
    
    var userNameLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 14))
    
    private var rightView: UIView = UIView.configureView(
        color: UIColor.white)
    
    var isTappedView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    
    
    
    
    private var stvEnum: CellSelectionUIStvEnum
    
    
    
    
    
    init(stvEnum: CellSelectionUIStvEnum) {
        self.stvEnum = stvEnum
        super.init(frame: .zero)
        
        self.configureStv()
        self.configureAutoLayout()
        self.configureUIWithEnum()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CellSelectionUIStv {
    // MARK: - UI 설정
    private func configureStv() {
        self.spacing = 7
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fill
        
        self.userNameLbl.text = "dfkj;asdkldfs"
        self.rightView.setRoundedCorners(.all, withCornerRadius: 26 / 2)
        self.isTappedView.setRoundedCorners(.all, withCornerRadius: 26 / 2)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.userNameLbl,
         self.rightView].forEach { view in
            self.addArrangedSubview(view)
        }
        self.addSubview(self.isTappedView)
        
        
        self.rightView.snp.makeConstraints { make in
            make.width.height.equalTo(26)
        }
        self.isTappedView.snp.makeConstraints { make in
            make.width.height.equalTo(22.5)
            make.centerX.centerY.equalTo(self.rightView)
        }
    }
    
    private func configureUIWithEnum() {
        if self.stvEnum == .peopleSelection {
            self.insertArrangedSubview(self.profileImg, at: 0)
            self.profileImg.snp.makeConstraints { make in
                make.width.height.equalTo(21)
            }
        }
    }
    
    
    func configureData(profile: UIImage? = nil,
                       userName: String) {
        
        
        
    }
}
