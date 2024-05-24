//
//  ChromaControlStylable.swift
//  EveryDutch
//
//  Created by 계은성 on 4/27/24.
//

import UIKit

// ChromaControlStylable 프로토콜
protocol ChromaControlStylable {
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor { get set }
    var showsShadow: Bool { get set }
    
    func updateShadowIfNeeded()
}
// ChromaControlStylable 프로토콜을 채택하는 UIView 확장
extension ChromaControlStylable where Self: UIView {
    func shadowProperties(forHeight height: CGFloat) -> ShadowProperties {
        let dropShadowHeight = height * 0.01
        return ShadowProperties(color: UIColor.black.cgColor, opacity: 0.35, offset: CGSize(width: 0, height: dropShadowHeight), radius: 4)
    }
}
