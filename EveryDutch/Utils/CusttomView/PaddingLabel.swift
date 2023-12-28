//
//  PaddingLabel.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/27.
//

import UIKit


final class PaddingLabel: UILabel {

    var topInset: CGFloat = 4.0
    var bottomInset: CGFloat = 4.0
    var leftInset: CGFloat = 12.0
    var rightInset: CGFloat = 12.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset,
                                  left: leftInset,
                                  bottom: bottomInset,
                                  right: rightInset)
        self.font = UIFont.systemFont(ofSize: 14)
        self.backgroundColor = .medium_Blue
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            self.preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
