//
//  UIStackView+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/27.
//

import UIKit

extension UIStackView {
    static func configureStv(
        arrangedSubviews: [UIView],
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat,
        alignment: UIStackView.Alignment,
        distribution: UIStackView.Distribution)
    -> UIStackView {
        let stv = UIStackView(arrangedSubviews: arrangedSubviews)
        stv.axis = axis
        stv.spacing = spacing
        stv.alignment = alignment
        stv.distribution = distribution
        return stv
    }
}
