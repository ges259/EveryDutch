//
//  UIDevice+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/28.
//

import UIKit

extension UIDevice {
    
    // 아이폰 분기처리
    public var isiPhoneSE: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            // iPhone 6, 6s, 7, 8, SE2, SE3
            && ((UIScreen.main.bounds.size.height == 667
                 && UIScreen.main.bounds.size.width == 375))
            // iPhone 6+, 6s+, 7+, 8+
            || ((UIScreen.main.bounds.size.height == 736
                 && UIScreen.main.bounds.size.width == 414)) {
            return true
        }
        // 나머지 false
        return false
    }
    
    // MARK: - Fix
    // 나중에 ViewModel로 옮기기
    public var tabBarHeight: CGFloat {
        return self.isiPhoneSE ? 62 : 97
    }
    // 이건 좀 이상하네
    public var topStackViewBottom: CGFloat {
//        return self.isiPhoneSE ? 62 : 62
        return self.isiPhoneSE ? 115 : 115
//        return self.isiPhoneSE ? 62 : 97
    }
    
    public var bottomBtnHeight: CGFloat {
        return self.isiPhoneSE ? 90 : 115
    }
    
    var panModalSafeArea: CGFloat {
        return self.isiPhoneSE ? 10 : 5
    }
    
    
//    public var panBottomAnchor: CGFloat {
//        return self.isiPhoneSE ? -10 : -10
//    }
    
    /// 나중에 추가
    /// topView
    /// topView - table
    /// topView - button
}
  
