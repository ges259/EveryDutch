//
//  ReadRoomMoneyData.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import Foundation
import FirebaseDatabaseInternal

// 방에 들어섰을 때
    // 방 유저 데이터 가져오기 ----- (Room_Users)

extension RoomsAPI {
    
    typealias RoomMoneyDataCompletion = (Result<[MoneyData], ErrorEnum>) -> Void
    

    
    func readRoomMoneyData(
        completion: @escaping RoomMoneyDataCompletion)
    {
        
        ROOM_MONEY_DATA_REF
            .child("version_ID_1")
            .observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String: [String: Any]] else {
                    completion(.failure(.readError))
                    return
                }
                
                var moneyDataDict = [MoneyData]()
                for (key, dict) in value {
                    // MoneyData 객체 만들기
                    let moneyData = MoneyData(
                        userID: key,
                        dictionary: dict)
                    // 딕셔너리에 추가
                    moneyDataDict.append(moneyData)
                }
                dump(moneyDataDict)
                // 반환
                completion(.success(moneyDataDict))
            }
    }
}
