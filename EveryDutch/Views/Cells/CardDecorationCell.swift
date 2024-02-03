//
//  CardDecorationTableView.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import UIKit

final class CardDecorationCell: UITableViewCell {
    
    // MARK: - 레이아웃
    
    
    
    // MARK: - 프로퍼티
    private var cellStv: CellSelectionUIStv = CellSelectionUIStv(
        stvEnum: .cardDecoration)
    
    
    
    
    
    
    
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

extension CardDecorationCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .medium_Blue
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
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
    func setDetailLbl(text: String) {
        self.cellStv.userNameLbl.text = text
    }
}
