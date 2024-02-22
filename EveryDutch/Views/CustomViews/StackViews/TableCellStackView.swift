//
//  TableCellStackView.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit
import SnapKit

final class TableCellStackView: UIStackView {
    
    // MARK: - 레이아웃
    var profileImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.black
        return img
    }()
    
    var userNameLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 14))
    
    lazy var priceLbl: CustomLabel = {
        let lbl = CustomLabel(
            text: "0원",
            backgroundColor: .medium_Blue,
            topBottomInset: 4,
            leftInset: 10,
            rightInset: 10)
        
        // 허깅 설정
        lbl.setContentHuggingPriority(
            UILayoutPriority.defaultHigh,
            for: .horizontal)
        // 모서리 설정
        lbl.setRoundedCorners(.all, withCornerRadius: 10)
       return lbl
    }()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var priceLblInStackView: Bool = true
    
    
    
    
    // MARK: - 라이프사이클
    init() {
        super.init(frame: .zero)
        
        self.configureStvUI()
        self.configureAutoLayout()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










// MARK: - 화면 설정

extension TableCellStackView {
    
    // MARK: - UI 설정
    private func configureStvUI() {
        self.spacing = 7
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fill
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.profileImg,
         self.userNameLbl,
         self.priceLbl].forEach { view in
            self.addArrangedSubview(view)
        }
        self.profileImg.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
    }
}
