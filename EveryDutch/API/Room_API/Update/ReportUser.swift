//
//  ReportUser.swift
//  EveryDutch
//
//  Created by 계은성 on 6/20/24.
//

import Foundation
import FirebaseDatabaseInternal

extension RoomsAPI {
    func reportUser(
        roomID: String,
        userID: String,
        completion: @escaping (Result<Int, ErrorEnum>) -> Void
    ) {
        // 해당 사용자의 데이터베이스 참조 생성
        let userRef = ROOM_USERS_REF.child(roomID).child(userID)
        
        // 트랜잭션 블록 시작
        userRef.runTransactionBlock(
            { currentData -> TransactionResult in
                // 현재 데이터를 가져옵니다. 데이터가 없다면 기본값 0을 사용
                var reportCount = currentData.value as? Int ?? 0
                // reportCount 값을 1 증가
                reportCount += 1
                // 증가된 값을 데이터베이스에 저장
                currentData.value = reportCount
                // 트랜잭션이 성공했음을 반환
                return TransactionResult.success(withValue: currentData)
                
            }, andCompletionBlock: { error, committed, snapshot in
                // 트랜잭션 완료 후 호출되는 블록
                
                if let _ = error {
                    // 에러가 발생한 경우, 실패 콜백 호출
                    completion(.failure(.readError))
                    
                } else if !committed {
                    // 트랜잭션이 커밋되지 않은 경우, 실패 콜백 호출
                    completion(.failure(.readError))
                    
                } else if let reportCount = snapshot?.value as? Int {
                    // 트랜잭션이 성공적으로 커밋된 경우, 새로운 reportCount 값을 성공 콜백으로 전달
                    completion(.success(reportCount))
                    
                } else {
                    // 데이터 타입이 예상과 다른 경우, 실패 콜백 호출
                    completion(.failure(.readError))
                }
            })
    }
}
