//
//  TableFooterView.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import UIKit

final class TableFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .medium_Blue
        self.setRoundedCorners(.bottom, withCornerRadius: 10)
        self.addShadow(shadowType: .bottom,
                       shadowOpacity: 0)
    }
}
