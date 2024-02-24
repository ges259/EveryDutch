//
//  NodataViewType.swift
//  EveryDutch
//
//  Created by 계은성 on 2/23/24.
//

import UIKit

enum NodataViewType {
    case mainScreen
    case versionScreen
    case ReceiptWriteScreen
    
    var getImg: UIImage? {
        switch self {
        case .mainScreen:
            return UIImage.plus_Circle_Img
        case .versionScreen:
            return UIImage.plus_Circle_Img
        case .ReceiptWriteScreen:
            return UIImage.plus_Circle_Img
        }
    }
    
    var getText: String {
        switch self {
        case .mainScreen:
            return "채팅방이 아직 없습니다.\n+ 버튼을 눌러 생성해보세요!"
        case .versionScreen:
            return "버전 정보가 없습니다.\n+ 정산 버튼을 눌러 버전을 생성해보세요!"
        case .ReceiptWriteScreen:
            return "채팅방이 아직 없습니다.\n+ 버튼을 눌러 생성해보세요!"
        }
    }
    var getTintColor: UIColor {
        switch self {
        case .mainScreen, .versionScreen:
            return .normal_white
            
        case .ReceiptWriteScreen:
            return .deep_Blue
        }
    }
    
    var getBackgroundColor: UIColor {
        switch self {
        case .mainScreen, .versionScreen:
            return .deep_Blue
        
        case .ReceiptWriteScreen:
            return .normal_white
        }
    }
    
    var getIsHidden: Bool {
        switch self {
        case .mainScreen, .versionScreen:
            return true
            
        case .ReceiptWriteScreen:
            return false
        }
    }
}

