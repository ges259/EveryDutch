//
//  CustomPickerDelegate.swift
//  EveryDutch
//
//  Created by 계은성 on 4/27/24.
//

import UIKit

protocol CustomPickerDelegate: AnyObject {
    func cancel(type: EditScreenPicker)
    func changedCropLocation(data: Any)
    func done<T>(with data: T)
}
