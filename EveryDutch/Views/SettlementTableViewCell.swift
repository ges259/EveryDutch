//
//  SettlementTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/27.
//

import UIKit
import SnapKit

final class SettlementTableViewCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private lazy var baseView: UIView = UIView.configureView(
        color: .normal_white)
    
    
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

extension SettlementTableViewCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.baseView.layer.cornerRadius = 8
        self.baseView.clipsToBounds = true
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.separatorInset = .zero
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.baseView)
        
        self.baseView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-3)
        }
        
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
    
    
}
