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
    case leftTop
    case rightTop
    case rightBottom
    
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
            return [.layerMaxXMinYCorner,
                    .layerMaxXMaxYCorner]
        case .left:
            return [.layerMinXMinYCorner,
                    .layerMinXMaxYCorner]
            
        case .leftTop:
            return [.layerMinXMinYCorner]
            
        case .rightTop:
            return [.layerMaxXMinYCorner]
        case .rightBottom:
            return [.layerMaxXMaxYCorner]
            
        case .none:
            return []
        }
    }
}
