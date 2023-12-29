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
        self.backgroundColor = .medium_Blue
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        super.drawText(in: rect.inset(by: insets))
    }
    init(topInset: CGFloat = 4,
         bottomInset: CGFloat = 4,
         leftInset: CGFloat = 12,
         rightInset: CGFloat = 12) {
        
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.leftInset = leftInset
        self.rightInset = rightInset
        
        super.init(frame: .zero)
    }
    convenience init(alignment: NSTextAlignment) {
        self.init(topInset: 4,
                  bottomInset: 4,
                  leftInset: 12,
                  rightInset: 26)
        self.textAlignment = NSTextAlignment.right
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
