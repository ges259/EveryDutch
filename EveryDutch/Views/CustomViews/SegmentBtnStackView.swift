//
//  ReceiptBtnStackView.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit
import SnapKit

final class SegmentBtnStackView: UIStackView {
    
    // MARK: - 레이아웃
    private var firstBtn: UIButton = UIButton.btnWithTitle(
        title: "누적 금액",
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.normal_white)

    private var secondBtn: UIButton = UIButton.btnWithTitle(
        title: "받아야 할 돈",
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.unselected_gray)
    
    
    // MARK: - 프로퍼티
    weak var delegate: ReceiptBtnStvDelegate?
    
    private let btnColorArray: [UIColor] = [.normal_white,
        .unselected_gray]
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        // 스택뷰 기본 설정
        self.axis = .horizontal
        self.spacing = 0
        self.alignment = .fill
        self.distribution = .fillEqually
        
        // 모서리 설정
        self.firstBtn.layer.maskedCorners = [.layerMinXMinYCorner]
        self.secondBtn.layer.maskedCorners = [.layerMaxXMinYCorner]
        self.firstBtn.layer.cornerRadius = 10
        self.secondBtn.layer.cornerRadius = 10
    }
    
    private func configureAutoLayout() {
        // 스택뷰에 버튼 넣기
        self.addArrangedSubview(self.firstBtn)
        self.addArrangedSubview(self.secondBtn)
        // 오토레이아웃 설정
        self.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
    }
    
    private func configureAction() {
        self.firstBtn.addTarget(
            self,
            action: #selector(self.firstBtnTapped),
            for: .touchUpInside)
        self.secondBtn.addTarget(
            self,
            action: #selector(self.secondBtnTapped),
            for: .touchUpInside)
    }
    
    @objc private func firstBtnTapped() {
        self.delegate?.firstBtnTapped(true)
        self.btnColorChange(isFirst: true)
    }
    @objc private func secondBtnTapped() {
        self.delegate?.firstBtnTapped(false)
        self.btnColorChange(isFirst: false)
    }
    
    

    
    
    func btnColorChange(isFirst: Bool) {
        // 첫 번째 버튼인지 확인
        let btnColor = isFirst
        ? self.btnColorArray
        : self.btnColorArray.reversed()
        
        // 버튼 색상 설정
        self.firstBtn.backgroundColor = btnColor[0]
        self.secondBtn.backgroundColor = btnColor[1]
    }
}


