//
//  CardTextEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/29.
//

import Foundation

enum CardTextMode {
    case roomFix
    case userInfoFix
    case nothingFix
    case setting
}

// roomFix
    // - 레이블 3개
    // - 버튼
    // - 텍스트필드 2개
// userInfoFix
    // - 레이블 3개
    // - 버튼
    // - 텍스트필드  1개
// nothingFix
    // - 레이블 3개
    // - 버튼 X
    // - 텍스트필드 0개

// setting
    // - 레이블 2개
    // - 버튼 X
    // - 텍스트필드  0개
