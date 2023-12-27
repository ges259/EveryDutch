//
//  TopViewTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/27.
//

import UIKit

final class TopViewTableViewCell: UITableViewCell {
    
    // MARK: - 레이아웃
    
    
    
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
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}
