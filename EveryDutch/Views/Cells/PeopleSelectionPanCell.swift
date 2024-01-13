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
            print("cellIsSelected ----- \(!self.cellIsSelected)")
            
            self.tableCellStv.rightImg.isHidden = !self.cellIsSelected
        }
    }
    
    
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
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
    func configureCellData(user: RoomUsers) {
        self.self.tableCellStv.rightImg.isHidden = true
        self.tableCellStv.profileImg.image = UIImage.person_Fill_Img
        self.tableCellStv.userNameLbl.text = user.roomName
        
        self.tableCellStv.rightImg.tintColor = UIColor.medium_Blue
        self.tableCellStv.rightImg.isHidden = true
        self.tableCellStv.rightImg.image = UIImage.circle_Fill_Img
    }
}
