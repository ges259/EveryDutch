//
//  searchMethodTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/04.
//

import UIKit
import SnapKit

final class PeopleSelectionPanCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private var tableCellStv: TableCellStackView = TableCellStackView(
        priceLblInStackView: false,
        rightImgInStackView: true)
    
    private var whiteView: UIView = UIView.configureView(
        color: UIColor.white)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    var cellIsSelected: Bool = false {
        didSet {
            self.tableCellStv.rightImg.isHidden = !self.cellIsSelected
        }
    }
    
    var isSingleMode: Bool = true
    
    
    
    
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool,
                              animated: Bool) {
        super.setSelected(selected, animated: animated)
        // 싱글 선택 모드라면.
        guard self.isSingleMode else { return }
        // 셀을 눌렀을 때, 해당 셀만 이미지 표시 (나머지는 이미지 숨기기)
        self.tableCellStv.rightImg.isHidden = selected
        ? false
        : true
    }
}

// MARK: - 화면 설정

extension PeopleSelectionPanCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .normal_white
        self.selectionStyle = .none
        self.separatorInset = .zero

        self.whiteView.clipsToBounds = true
        self.whiteView.layer.cornerRadius = 27 / 2
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.whiteView)
        self.addSubview(self.tableCellStv)
        
        self.tableCellStv.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        self.whiteView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-17)
            make.width.height.equalTo(27)
            make.centerY.equalTo(self.tableCellStv)
        }
    }
    
    // MARK: - 셀의 데이터 설정
    func configureCellData(userID: String,
                           user: RoomUsers) {
        self.self.tableCellStv.rightImg.isHidden = true
        self.tableCellStv.profileImg.image = UIImage.person_Fill_Img
        
        self.tableCellStv.rightImg.tintColor = UIColor.medium_Blue
        self.tableCellStv.rightImg.isHidden = true
        self.tableCellStv.rightImg.image = UIImage.circle_Fill_Img
        
        
        self.tableCellStv.userNameLbl.text = user.roomUserName
        self.tableCellStv.rightImg.isHidden = !self.cellIsSelected
    }
}
