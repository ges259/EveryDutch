//
//  Image_Enum.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import Foundation

enum imageEnum {
    case plus
    case person
    case person_Fill
    
    case trash
    case recycle
    case gear
    case gear_Fill
    case exit
    case invite
    case empty_Square
    case check_Square
    case empty_Cirle
    case circle_Fill
    case clock
    case note
    case won
    case card
    case n_Mark
    case calendar
    case checkMark
    case chevronLeft
    case chevronRight
    case menu
    
    var img_String: String {
        switch self {
        case .plus: return "plus"
        case .person: return "person.crop.circle"
        case .person_Fill: return "person.crop.circle.fill"
        case .trash: return "trash.circle.fill"
        case .recycle: return "arrow.counterclockwise.circle.fill"
        case .gear: return "gearshape"
        case .gear_Fill: return "gearshape.fill"
        case .exit: return "rectangle.portrait.and.arrow.right"
        case .invite: return "person.crop.circle.fill.badge.plus"
        case .empty_Square: return "square"
        case .check_Square: return "checkmark.square.fill"
        case .empty_Cirle: return "circle"
        case .circle_Fill: return "circle.fill"
        case .clock: return "clock"
        case .note: return "square.and.pencil"
        case .won: return "wonsign.circle"
        case .card: return "creditcard.circle"
        case .n_Mark: return "n.circle"
        case .calendar: return "calendar.circle"
        case .checkMark: return "checkmark"
        case .chevronLeft: return "chevron.left"
        case .chevronRight: return "chevron.right"
        case .menu: return "line.3.horizontal"
        }
    }
}
