//
//  ProfileTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2/1/24.
//

import UIKit
import SnapKit

final class ProfileTableViewCell: UITableViewCell {
    
    
    var detailLbl: CustomLabel = CustomLabel(
        leftInset: 20)
    
    var infoLbl: CustomLabel = CustomLabel(
        textAlignment: .right,
        rightInset: 20)
    
    
    
    
    // MARK: - 라이프 사이클
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

extension ProfileTableViewCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .medium_Blue
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.detailLbl)
        self.addSubview(self.infoLbl)
        
        self.detailLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        // 기존의 configureAutoLayout() 메서드 내부의 infoLbl 제약 조건을 수정합니다.
        self.infoLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(_ data: String) {
        self.detailLbl.text = data
        self.infoLbl.text = "1111"
    }
}
