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
// Rooms_Thumbnails
extension DatabaseConstants {
    static let room_name: String = "room_name"
    static let room_image: String = "roomimage"
    
    static let room_user_name: String = "room_user_name"
    static let room_user_image: String = "room_user_image"
}


// Receipt
extension DatabaseConstants {
    static let type: String = "type"
    static let context: String = "context"
    static let date: String = "date"
    static let time: String = "time"
    static let price: String = "price"
    static let payer: String = "payer"
    static let payment_method: String = "paymentMethod"
    static let payment_details: String = "paymentDetails"
    
    static let pay: String = "pay"
    static let done: String = "done"
}



extension DatabaseConstants {
    static let culmulative_money: String = "Cumulative_Amount"
    static let payback: String = "Payback"
    static let saveReceipt: String = "SaveReceipt"
    static let createReceipt: String = "CreateReceipt"
}
