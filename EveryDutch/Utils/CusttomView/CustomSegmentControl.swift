//
//  CustomSegmentControl.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/28.
//

import UIKit

final class CustomSegmentControl: UISegmentedControl {
    
    override func draw(_ rect: CGRect) {
        // segment 배경색 (비 선택창)
        self.backgroundColor = UIColor.unselected_gray
        // segement 선택창 배경 색
        self.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
        self.tintColor = .red
        self.selectedSegmentTintColor = UIColor(white: 1, alpha: 0.3)
        // 기본 설정 - 0번 인덱스 (누적 금액)
        self.selectedSegmentIndex = 0
        
        self.selectedSegmentTintColor = .normal_white
        super.draw(rect)
    }
}
