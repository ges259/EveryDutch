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
    

    

    
    func readCumulativeAmount(
        versionID: String,
        completion: @escaping Typealias.RoomMoneyDataCompletion)
    {
        
        Cumulative_AMOUNT_REF
            .child(versionID)
            .observeSingleEvent(of: .value) { snapshot in
                
                guard let value = snapshot.value as? [String: Int] else {
                    // 데이터를 가져오는데 실패한 경우, 에러와 함께 완료 핸들러를 호출
                    completion(.failure(.readError))
                    return
                }
                var cumulativeAmounts: CumulativeAmountDictionary = [:]
                
                
                for (userID, amount) in value {
                    let moneyData = CumulativeAmount(
                        amount: amount)
                    cumulativeAmounts[userID] = moneyData
                }
                // 결과적으로 생성된 CumulativeAmount 배열
                completion(.success(cumulativeAmounts))
            }
    }
    
    
    
    func readPayback(
        versionID: String,
        completion: @escaping Typealias.PaybackCompletion)
    {
        
        
        
        PAYBACK_REF
            .child(versionID)
            .child("qqqqqq")
            .observeSingleEvent(of: .value, with: { snapshot in
                
                guard let value = snapshot.value as? [String: Int] else {
                    // 데이터를 가져오는데 실패한 경우, 에러와 함께 완료 핸들러를 호출
                    completion(.failure(.readError))
                    return
                }
                
                let payback = Payback(
                    userID: "qqqqqq",
                    payback: value)
                
                // 완료 핸들러에 성공 결과 전달
                completion(.success(payback))
            })
    }
}
