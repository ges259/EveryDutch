//
//  ToolbarStackView.swift
//  EveryDutch
//
//  Created by 계은성 on 4/13/24.
//

import UIKit
import SnapKit

final class ToolbarStackView: UIStackView {
    
    // MARK: - 레이아웃
    private let doneButton: UIButton = UIButton.btnWithTitle(
        title: "저장",
        font: UIFont.boldSystemFont(ofSize: 15),
        backgroundColor: .clear)
    
    private let cancelBtn: UIButton = UIButton.btnWithTitle(
        title: "취소",
        font: UIFont.boldSystemFont(ofSize: 15),
        backgroundColor: .clear)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupStackView()
        self.setupUI()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        self.spacing = 0
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fill
        
        self.backgroundColor = UIColor.deep_Blue
    }
    
    
    private func setupUI() {
        self.addArrangedSubview(self.cancelBtn)
        self.addArrangedSubview(UIView())
        self.addArrangedSubview(self.doneButton)
        
        self.doneButton.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        self.cancelBtn.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
    }
    
    
    private func setupAction() {
        
    }
    
    
    
    @objc
    func cancel() {
        print(#function)
    }
    @objc
    func done() {
        print(#function)
    }
}
