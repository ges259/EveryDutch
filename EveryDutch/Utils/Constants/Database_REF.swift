//
//  Database_REF.swift
//  EveryDutch
//
//  Created by 계은성 on 1/10/24.
//

import Foundation
import Firebase
import FirebaseDatabaseInternal

let ref = Database.database().reference()

// MARK: - Users_API
// User
let USER_REF = ref.child("Users")

// MARK: - Rooms_API
// Room_ID
let ROOMS_REF = ref.child("Rooms")
// User_RoomsID
let USER_ROOMSID = ref.child("User_RoomsID")
// Room_users
let ROOM_USERS_REF = ref.child("Room_Users")

// Room_Money_Data
let PAYBACK_REF = ref.child("Payback")
let CUMULATIVE_AMOUNT_REF = ref.child("Cumulative_Amount")

// MARK: - Receipt_API
// Receipt
let RECEIPT_REF = ref.child("Receipt")
// User_Receipts
let USER_RECEIPTS_REF = ref.child("User_Receipts")

// MARK: - Version_API
// Version_Thumbnail
let VERSION_THUMBNAIL_REF = ref.child("Version_Thumbnail")



// MARK: - Card_Decoration
let CARD_DECORATION_REF = ref.child("Card_Decoration")



// MARK: - Rollback_ERROR_API
//let Rollback_ERROR_REF = ref.child("Rollback_Error")
