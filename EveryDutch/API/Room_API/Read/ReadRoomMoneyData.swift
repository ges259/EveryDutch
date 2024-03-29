//
//  ReadRoomMoneyData.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import Foundation
import FirebaseAuth
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
                
                // 데이터가 존재하지 않는 경우
                guard snapshot.exists() else {
                    // 빈 배열로 성공 응답
                    completion(.success([:]))
                    return
                }
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
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        PAYBACK_REF
            .child(versionID)
            .child(uid)
            .observeSingleEvent(of: .value, with: { snapshot in
                
                // 데이터가 존재하지 않는 경우
                guard snapshot.exists() else {
                    let payback = Payback(
                        userID: uid,
                        payback: [:])
                    // 빈 배열로 성공 응답
                    completion(.success(payback))
                    return
                }
                
                guard let value = snapshot.value as? [String: Int] else {
                    // 데이터를 가져오는데 실패한 경우, 에러와 함께 완료 핸들러를 호출
                    completion(.failure(.readError))
                    return
                }
                
                let payback = Payback(
                    userID: uid,
                    payback: value)
                
                // 완료 핸들러에 성공 결과 전달
                completion(.success(payback))
            })
    }
}
