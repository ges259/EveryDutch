//
//  BottomButton.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/05.
//

import UIKit

final class BottomButton: UIButton {
    
    init(title: String = "",
         cornerRadius: CGFloat = 35) {
        super.init(frame: .zero)
        
        // 타이틀 설정
        self.setTitle(title, for: .normal)
        // 타이틀 생상 설정
        self.setTitleColor(UIColor.black, for: .normal)
        // 타이틀 폰트 설정
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        // 버튼의 배경 설정
        self.backgroundColor = UIColor.deep_Blue
        // 모서리 설정 (상단)
        self.clipsToBounds = true
        self.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner]
        self.layer.cornerRadius = cornerRadius
        
        // 그림자 설정
        self.addShadow(top: true, bottom: false)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
