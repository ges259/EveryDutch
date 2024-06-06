//
//  DatabaseEnum.swift
//  EveryDutch
//
//  Created by 계은성 on 1/10/24.
//

import Foundation

extension DatabaseConstants {
    static let userID: String = "userID"
}


// Users
enum DatabaseConstants {
    static let email: String = "email"
    static let personal_ID: String = "personal_ID"
    static let user_image: String = "user_image"
    static let user_name: String = "user_name"
}



// Receipt
extension DatabaseConstants {
    static let type: String = "type"
    static let done: String = "done"
    
    
    static let date: String = "date"
    static let time: String = "time"
    
    static let context: String = "context"
    static let price: String = "price"
    static let payer: String = "payer"
    
    static let payment_method: String = "paymentMethod"
    
    
    static let payment_details: String = "paymentDetails"
    
    static let pay: String = "pay"
    
}



extension DatabaseConstants {
    static let culmulative_money: String = "Cumulative_Amount"
    static let payback: String = "Payback"
    static let saveReceipt: String = "SaveReceipt"
    static let createReceipt: String = "CreateReceipt"
}






// Rooms_Thumbnails
extension DatabaseConstants {
    
    static let room_name: String = "room_name"
    static let class_name: String = "class_name"
    static let manager_name: String = "manager_name"
    static let room_manager: String = "room_manager"
    static let version_ID: String = "version_ID"
}
extension DatabaseConstants {
    
    static let blur_Effect: String = "blur_Effect"
    static let title_Color: String = "title_Color"
    static let name_Color: String = "name_Color"
    static let background_Data: String = "background_Data"
    
    static let duplicatePersonalID: String = "duplicatePersonalID"
}
