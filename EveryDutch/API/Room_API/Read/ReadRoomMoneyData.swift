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
extension Notification.Name {
//    static let cumulativeAmountUpdated = Notification.Name("cumulativeAmountUpdated")
//    static let paybackDataUpdated = Notification.Name("paybackDataUpdated")
//    static let roomUsersUpdated = Notification.Name("roomUsersUpdated")
    static let userDataChanged = Notification.Name("userDataChanged")
    static let financialDataUpdated = Notification.Name("financialDataUpdated")
}

//// 이 코드는, childChanged

extension RoomsAPI {
    
    func readCumulativeAmount(
        versionID: String,
        completion: @escaping (Result<[String: Int], ErrorEnum>) -> Void)
    {
        let path = CUMULATIVE_AMOUNT_REF.child(versionID)
        
        // 데이터 초기 로드
        path.observeSingleEvent(of: .value) { snapshot in
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
            var cumulativeAmounts: [String: Int] = [:]
            
            for (userID, amount) in value {
                cumulativeAmounts[userID] = amount
            }
            // 결과적으로 생성된 CumulativeAmount 배열
            completion(.success(cumulativeAmounts))
        }
        
        // 데이터가 변경되었을 때
        path.observe(.childChanged) { snapshot in
            guard snapshot.exists(),
                  let key = snapshot.key as String?,
                  let value = snapshot.value as? Int
            else {
                // 빈 배열로 성공 응답
                completion(.failure(.readError))
                return
            }
            
            // 단일 변경 사항을 전달
            let updatedCumulativeAmount = [key: value]
            completion(.success(updatedCumulativeAmount))
        }
    }
    
    
    
    func readPayback(
        versionID: String,
        completion: @escaping (Result<[String: Int], ErrorEnum>) -> Void)
    {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let path = PAYBACK_REF.child(versionID).child(uid)
        
        path.observeSingleEvent(of: .value) { snapshot in
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
            // 완료 핸들러에 성공 결과 전달
            completion(.success(value))
        }
        
        // 데이터가 변경되었을 때
        path.observe(.childChanged) { snapshot in
            guard snapshot.exists(),
                  let key = snapshot.key as String?,
                  let value = snapshot.value as? Int
            else {
                // 빈 배열로 성공 응답
                completion(.failure(.readError))
                return
            }
            
            // 단일 변경 사항을 전달
            let updatedCumulativeAmount = [key: value]
            completion(.success(updatedCumulativeAmount))
        }
    }
}
