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
    private var cellStv: CellSelectionUIStv = CellSelectionUIStv(
        stvEnum: .peopleSelection)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    var cellIsSelected: Bool = false {
        didSet {
            
            self.cellStv.isTappedView.isHidden = !self.cellIsSelected
            
            print("cellIsSelected")
            print(self.cellIsSelected)
            print(self.cellStv.isTappedView.isHidden)
        }
    }
    
    private var isSingleMode: Bool = true
    
    
    
    
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
        self.cellStv.isTappedView.isHidden = selected
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
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.cellStv)
        
        self.cellStv.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - 셀의 데이터 설정
    func configureCellData(isSingleMode: Bool,
                           isSelected: Bool,
                           userID: String,
                           user: RoomUsers) {
        // 모드 설정
        self.isSingleMode = isSingleMode
        // 셀이 선택되었는지 확인
        self.cellIsSelected = isSelected
        // 프로필 이미지 설정
        self.cellStv.profileImg.image = UIImage.person_Fill_Img
        // 이름 설정
        self.cellStv.userNameLbl.text = user.roomUserName
    }
}
