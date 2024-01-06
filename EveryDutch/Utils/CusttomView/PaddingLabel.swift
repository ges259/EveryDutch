//
//  PaddingLabel.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/27.
//

import UIKit


final class PaddingLabel: UILabel {

    var topBottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0


    init(text: String = "",
         textColor: UIColor = UIColor.black,
         font: UIFont = UIFont.systemFont(ofSize: 13),
         backgroundColor: UIColor = .clear,
         textAlignment: NSTextAlignment = .left,
         topBottomInset: CGFloat = 0,
         leftInset: CGFloat = 0,
         rightInset: CGFloat = 0) {
        
        self.topBottomInset = topBottomInset
        self.leftInset = leftInset
        self.rightInset = rightInset
        
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.font = font
        self.backgroundColor = backgroundColor
        self.textAlignment = textAlignment
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: self.topBottomInset,
                                  left: self.leftInset,
                                  bottom: self.topBottomInset,
                                  right: self.rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topBottomInset + topBottomInset)
    }

    override var bounds: CGRect {
        didSet {
            self.preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
