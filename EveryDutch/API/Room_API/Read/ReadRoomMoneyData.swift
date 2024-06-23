//
//  ReadRoomMoneyData.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabaseInternal

extension RoomsAPI {
    // MARK: - 스냅샷 데이터 가공
    private func moneyDataSnapshot(
        _ snapshot: DataSnapshot,
        completion: @escaping (Result<[String: Int], ErrorEnum>) -> Void)
    {
        guard snapshot.exists(),
              let key = snapshot.key as String?
        else {
            // 빈 배열로 성공 응답
            completion(.failure(.readError))
            return
        }
        let value = snapshot.value as? Int ?? 0
        // 단일 변경 사항을 전달
        let updatedCumulativeAmount = [key: value]
        completion(.success(updatedCumulativeAmount))
    }
    
    // MARK: - 누적금액
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
        // 데이터가 추가되었을 때
        path.observe(.childAdded) { snapshot in
            self.moneyDataSnapshot(snapshot, completion: completion)
        }
        // 데이터가 변경되었을 때
        path.observe(.childChanged) { snapshot in
            self.moneyDataSnapshot(snapshot, completion: completion)
        }
    }
    
    // MARK: - 페이백
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
        // 데이터가 추가되었을 때
        path.observe(.childAdded) { snapshot in
            self.moneyDataSnapshot(snapshot, completion: completion)
        }
        // 데이터가 변경되었을 때
        path.observe(.childChanged) { snapshot in
            self.moneyDataSnapshot(snapshot, completion: completion)
        }
    }
}
