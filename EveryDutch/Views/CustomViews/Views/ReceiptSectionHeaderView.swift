//
//  ReceiptSectionHeaderView.swift
//  EveryDutch
//
//  Created by 계은성 on 6/24/24.
//

import UIKit

final class ReceiptSectionHeaderView: UITableViewHeaderFooterView {
    private let dateLabel: CustomLabel = {
        let label = CustomLabel(
            textAlignment: .center,
            topBottomInset: 5,
            leftInset: 12,
            rightInset: 12
        )
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.setRoundedCorners(.all, withCornerRadius: 10)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // 위 아래로 뒤집기
        self.transform = CGAffineTransform(rotationAngle: .pi)
        // 배경 색상
        self.backgroundColor = .clear
        
        // 오토레이아웃 설정
        self.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
//            make.leading.trailing.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 섹션 헤더의 날짜 설정
    func configure(with date: String?,
                   labelBackgroundColor: UIColor) {
        self.dateLabel.text = date
        self.dateLabel.backgroundColor = labelBackgroundColor
    }
}
