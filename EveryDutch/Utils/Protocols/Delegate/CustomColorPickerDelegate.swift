//
//  CustomColorPickerDelegate.swift
//  EveryDutch
//
//  Created by 계은성 on 4/27/24.
//

import UIKit

// MARK: - Delegate
protocol CustomColorPickerDelegate: AnyObject {
    /// 뷰의 높이에 기반한 그림자 속성을 계산하여 반환하는 메서드
    func colorPickerHandleDidChange(_ colorPicker: ChromaColorPicker, handle: ChromaColorHandle, to color: UIColor)
}
