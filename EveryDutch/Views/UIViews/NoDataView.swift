//
//  NoDataView.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/29.
//

import UIKit
import SnapKit

final class NoDataView: UIView {
    
    // MARK: - 레이아웃
    private var noDataImg: UIImageView = UIImageView()
    
    private var noDataText: CustomLabel = {
        let lbl = CustomLabel(
            font: UIFont.systemFont(ofSize: 17),
            textAlignment: .center)
        lbl.numberOfLines = 2
        return lbl
    }()
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.noDataImg,
                           self.noDataText],
        axis: .vertical,
        spacing: 14,
        alignment: .center,
        distribution: .fill)
    
    
    
    // MARK: - 프로퍼티
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension NoDataView {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = UIColor.deep_Blue
        self.noDataImg.tintColor = .normal_white
        
        
        // MARK: - Fix
        self.noDataImg.image = UIImage.plus_Circle_Img
        self.noDataText.text = "채팅방이 아직 없습니다.\n+ 버튼을 눌러 생성해보세요!"
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        self.noDataImg.snp.makeConstraints { make in
            make.width.height.equalTo(110)
        }
    }
}
