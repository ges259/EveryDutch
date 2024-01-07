//
//  searchMethodTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/04.
//

import UIKit
import SnapKit

final class SearchMethodTableViewCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private var nameLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 15))
    
    private lazy var rightImg: UIButton = UIButton.btnWithImg(
        image: .circle_Fill_Img,
        imageSize: 13,
        tintColor: UIColor.deep_Blue)
    
    private var whiteView: UIView = UIView.configureView(
        color: UIColor.white)
    
    
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

extension SearchMethodTableViewCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = UIColor.normal_white
        self.nameLbl.text = "지출 내역"

        self.whiteView.clipsToBounds = true
        self.whiteView.layer.cornerRadius = 27 / 2
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.nameLbl)
        self.addSubview(self.whiteView)
        self.addSubview(self.rightImg)
        
        
        
        self.nameLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(23)
            make.centerY.equalToSuperview()
        }
        self.rightImg.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        self.whiteView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.rightImg)
            make.width.height.equalTo(27)
        }
        
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}
