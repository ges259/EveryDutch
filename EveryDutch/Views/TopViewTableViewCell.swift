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
        font: UIFont.systemFont(ofSize: 15))
    
    private var priceLbl: PaddingLabel = PaddingLabel()
    
    private var rightImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = .gray
        return img
    }()
    
    private lazy var leftStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.profileImg,
                           self.userName],
        axis: .horizontal,
        spacing: 7,
        alignment: .fill,
        distribution: .fill)
    
    
    private lazy var rightStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.priceLbl,
                           self.rightImg],
        axis: .horizontal,
        spacing: 10,
        alignment: .center,
        distribution: .equalCentering)
    
    // MARK: - 프로퍼티
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.configureAutoLayout()
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
        
        
        
        // MARK: - Fix
        self.profileImg.image = UIImage.person_Fill_Img
        self.rightImg.image = UIImage.chevronRight
        
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
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.leftStackView)
        self.addSubview(self.rightStackView)
        
        self.profileImg.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
        self.rightImg.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.width.equalTo(10)
            
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
    }
}
