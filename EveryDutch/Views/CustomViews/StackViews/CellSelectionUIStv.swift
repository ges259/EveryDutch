//
//  CellSelectionUIStv.swift
//  EveryDutch
//
//  Created by 계은성 on 2/8/24.
//

import UIKit

final class CellSelectionUIStv: UIStackView {
    
    // MARK: - 레이아웃
    lazy var profileImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.black
        return img
    }()
    
    var userNameLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 14))
    
    var rightView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .white
        return img
    }()
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










// MARK: - 화면 설정
extension CellSelectionUIStv {
    /// 초기 설정
    private func configureUIWithEnum() {
        if self.stvEnum == .peopleSelection {
            self.insertArrangedSubview(self.profileImg, at: 0)
            self.profileImg.snp.makeConstraints { make in
                make.width.height.equalTo(21)
            }
        }
    }
    /// UI 설정
    private func configureStv() {
        self.spacing = 7
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fill
        
        self.isTappedView.isHidden = true
        
        self.rightView.setRoundedCorners(.all, withCornerRadius: 26 / 2)
        self.isTappedView.setRoundedCorners(.all, withCornerRadius: 22.5 / 2)
    }
    
    /// 오토레이아웃 설정
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
    
    
    
    
    
    
    // MARK: - 화면 데이터 설정
//    func configureData(profile: UIImage? = nil,
//                       userName: String) {
//        
//    }
    
    func isTapped(color: UIColor?) {
        self.isTappedView.isHidden = false
        self.isTappedView.backgroundColor = color
    }
}

