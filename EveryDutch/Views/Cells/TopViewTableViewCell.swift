//
//  TopViewTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/27.
//

import UIKit
import SnapKit

final class TopViewTableViewCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private var profileImg: UIImageView = UIImageView()
    
    private var userName: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 14))
    
    private var priceLbl: PaddingLabel = PaddingLabel(
        backgroundColor: .medium_Blue,
        topBottomInset: 4,
        leftRightInset: 10)
    
    private var priceTf: InsetTextField = InsetTextField(
        backgroundColor: UIColor.medium_Blue,
        placeholerColor: .placeholder_gray,
        placeholderText: "가격 입력")

    private lazy var rightBtn: UIButton = UIButton.btnWithImg(
        imageEnum: .check_Square,
        imageSize: 13)
    // chevronRight
    private lazy var whiteView: UIView = UIView.configureView(
        color: UIColor.white)
    
    private lazy var leftStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.profileImg,
                           self.userName],
        axis: .horizontal,
        spacing: 8,
        alignment: .fill,
        distribution: .fill)
    
    
    private lazy var rightStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.priceLbl,
                           self.rightBtn],
        axis: .horizontal,
        spacing: 17,
        alignment: .center,
        distribution: .equalCentering)
    
    
    
    // MARK: - 프로퍼티
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension TopViewTableViewCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .normal_white
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.priceLbl.clipsToBounds = true
        self.priceLbl.layer.cornerRadius = 10
        
        // MARK: - Fix
        self.profileImg.image = UIImage.person_Fill_Img
        
        let nameString = ["쁨",
                          "노주영",
                          "맥형",
                          "김게성",
                          "기덩",
                          "소주안마시는근육몬",
                          "지후",
        ]
        let priceString = ["120,000원",
                            "80,000원",
                            "100원",
                            "550,000원",
                            "1,000원"]
        self.userName.text = nameString.randomElement()
        
        self.priceLbl.text = priceString.randomElement()
        self.profileImg.tintColor = .black
        self.priceTf.isHidden = true
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.leftStackView)
        self.addSubview(self.whiteView)
        self.contentView.addSubview(self.rightStackView)
        self.contentView.addSubview(self.priceTf)
        
        self.profileImg.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
        self.leftStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        self.rightStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(22)
        }
        
        // MARK: - Fix
        self.priceTf.snp.makeConstraints { make in
            make.trailing.equalTo(self.rightStackView).offset(-17)
            make.width.equalTo(self.frame.width / 2 - 30)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        
//        self.whiteView.clipsToBounds = true
//        self.whiteView.layer.cornerRadius = 27 / 2
//        self.rightBtn.tintColor = UIColor.deep_Blue
//
//        self.whiteView.snp.makeConstraints { make in
//            make.centerX.centerY.equalTo(self.rightBtn)
//            make.width.height.equalTo(27)
//        }
    }
    
    private func configureAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.priceLblTapped))
        self.priceLbl.isUserInteractionEnabled = true // 레이블이 사용자 인터랙션을 받도록 설정
        self.priceLbl.addGestureRecognizer(tapGesture)
        
        self.rightBtn.addTarget(self, action: #selector(self.rightBtnTapped), for: .touchUpInside)
    }
    @objc func rightBtnTapped() {
        self.priceTf.isHidden = true
    }
    @objc func priceLblTapped() {
        // 레이블이 탭됐을 때 실행할 코드를 여기에 추가합니다.
        print("Label was tapped")
        self.priceTf.isHidden = false
    }
}
