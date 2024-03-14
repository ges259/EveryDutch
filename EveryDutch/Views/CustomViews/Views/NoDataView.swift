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
    
    private var noDataText: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.numberOfLines = 2
        return lbl
    }()
    private lazy var stackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.noDataImg,
                           self.noDataText],
        axis: .vertical,
        spacing: 14,
        alignment: .center,
        distribution: .fill)
    
    
    
    // MARK: - 프로퍼티
    
    
    
    
    
    // MARK: - 라이프사이클
    init(type: NodataViewType) {
        super.init(frame: .zero)
        
        self.configureUIWithType(type: type)
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










// MARK: - 화면 설정

extension NoDataView {
    
    // MARK: - UI 설정
    func configureUIWithType(type: NodataViewType) {
        self.backgroundColor = type.getBackgroundColor
        self.isHidden = type.getIsHidden
        self.noDataImg.image = type.getImg
        self.noDataText.text = type.getText
        self.noDataImg.tintColor = type.getTintColor
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
