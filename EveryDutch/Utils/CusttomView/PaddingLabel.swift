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
        let insets = UIEdgeInsets(top: self.topInset,
                                  left: self.leftInset,
                                  bottom: self.bottomInset,
                                  right: self.rightInset)
        self.font = UIFont.systemFont(ofSize: 13)
        super.drawText(in: rect.inset(by: insets))
    }
    init(leftInset: CGFloat = 12,
         rightInset: CGFloat = 12,
         backgroundColor: UIColor = .clear) {
        self.leftInset = leftInset
        self.rightInset = rightInset
        
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    convenience init(alignment: NSTextAlignment,
                     leftInset: CGFloat = 12,
                     rightInset: CGFloat = 12,
                     backgroundColor: UIColor = .clear) {
        self.init(leftInset: 12,
                  rightInset: 12,
                  backgroundColor: backgroundColor)
        self.textAlignment = alignment
        self.textColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
