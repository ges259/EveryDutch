//
//  CardImageView.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/29.
//

import UIKit
import SnapKit

final class CardImageView: UIView {
    
    // MARK: - 레이아웃
    private var backgroundImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.medium_Blue
        return img
    }()
    private var titleLbl: CustomLabel = CustomLabel(
        font: .boldSystemFont(ofSize: 25))
    
    private var dutchImg: UIImageView = UIImageView()
    
    private var arrowImg: UIImageView = UIImageView()
    
    private var lineView: UIView = UIView.configureView(
        color: UIColor.normal_white)
    
    private var nameLbl: CustomLabel = CustomLabel(
        textColor: .placeholder_gray,
        font: UIFont.systemFont(ofSize: 13))
    
    private var userImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.black
        return img
    }()
    
    private var blurView: UIView = UIView.configureView(
        color: .white.withAlphaComponent(0.38))
    
    
    // MARK: - 프로퍼티
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension CardImageView {
    
    // MARK: - UI 설정
    private func configureUI() {
        
//        self.addShadow(shadowType: .card)
        self.backgroundImg.setRoundedCorners(.all, withCornerRadius: 10)
        self.blurView.setRoundedCorners(.all, withCornerRadius: 10)
        self.blurView.isHidden = true
        
        // MARK: - Fix
        self.titleLbl.text = "더치더치"
        self.nameLbl.text = "김게성성"
        
        self.userImg.image = UIImage.person_Fill_Img
        self.arrowImg.image = UIImage.chevronLeft
        self.dutchImg.backgroundColor = .normal_white
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.backgroundImg,
         self.arrowImg,
         self.titleLbl,
         self.dutchImg,
         self.lineView,
         self.nameLbl,
         self.userImg,
         self.blurView].forEach { view in
            self.addSubview(view)
        }
        
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.titleLbl.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
        }
        self.arrowImg.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview().offset(-10)
            make.width.equalTo(10)
            make.height.equalTo(20)
        }
        self.dutchImg.snp.makeConstraints { make in
            make.leading.equalTo(self.arrowImg.snp.trailing).offset(12)
            make.centerY.equalTo(self.arrowImg)
            make.width.height.equalTo(45)
        }
        self.lineView.snp.makeConstraints { make in
            make.top.equalTo(self.dutchImg.snp.bottom).offset(10)
            make.leading.equalTo(self.dutchImg.snp.leading)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(2)
        }
        self.nameLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        self.userImg.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-20)
            make.width.height.equalTo(30)
        }
        self.blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
    
    
    func titleColorChange(color: UIColor) {
        self.titleLbl.textColor = color
    }
    func pointColorChange(color: UIColor) {
        self.lineView.backgroundColor = color
    }
    func backgroundColorChange(color: UIColor) {
        self.backgroundImg.backgroundColor = color
    }
    func backgroundImgChange(image: UIImage?) {
        self.backgroundImg.image = image
    }
    func profileImgChange(image: UIImage?) {
        self.userImg.image = image
    }
    func blurViewIsHidden(_ isHidden: Bool) {
    // MARK: - Fix
//        self.blurView.isHidden = isHidden
        self.blurView.isHidden.toggle()
    }
    
    
    func configureUserData(data userData: User) {
        self.titleLbl.text = userData.userName
        self.nameLbl.text = userData.personalID
    }
}
