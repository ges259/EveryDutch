//
//  CornerRoundType.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import QuartzCore

enum CornerRoundType {
    case top
    case bottom
    case all
    case none
    case right
    case left
    case rightTop
    
    var cornerMask: CACornerMask {
        switch self {
        case .top:
            return [.layerMinXMinYCorner,
                    .layerMaxXMinYCorner]
        case .bottom:
            return [.layerMinXMaxYCorner,
                    .layerMaxXMaxYCorner]
        case .all:
            return [.layerMinXMinYCorner,
                    .layerMaxXMinYCorner,
                    .layerMinXMaxYCorner,
                    .layerMaxXMaxYCorner]
        case .right:
            return [.layerMinXMinYCorner,
                    .layerMinXMaxYCorner]
        case .left:
            return [.layerMaxXMinYCorner,
                    .layerMaxXMaxYCorner]
        case .rightTop:
            return [.layerMinXMinYCorner]
        case .none:
            return []
        }
    }
}
