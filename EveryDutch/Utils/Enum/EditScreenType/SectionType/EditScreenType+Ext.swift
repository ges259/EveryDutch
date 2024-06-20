//
//  CommonEditScreenType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/1/24.
//

import Foundation

// MARK: - 공통 함수
extension EditScreenType {
    
    // MARK: - 바텀 버튼 타이틀
    func bottomBtnTitle(isMake: Bool) -> String? {
        return isMake
        ? "수정 완료"
        : "생성 완료"
    }
    
    // MARK: - 데코 관련 코드
    var cardHeaderTitle: String {
        return "카드 효과 설정"
    }
    var imageHeaderTitle: String {
        return "이미지 설정"
    }
}
