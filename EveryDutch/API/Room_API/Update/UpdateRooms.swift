//
//  UpdateRooms.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation

// 유저 닉네임 및 이미지 변경
// 버전 변경

extension RoomsAPI {
    
    // MARK: - Rooms 업데이트
    func updateData(IdRef roomID: String, dict: [String: Any]) async throws {
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            // 새로운 방 생성 및 정보 업데이트
            ROOMS_REF
                .child(roomID)
                .updateChildValues(dict) { error, ref in
                    
                    guard error == nil else {
                        continuation.resume(throwing: ErrorEnum.writeError)
                        return
                    }
                    continuation.resume(returning: ())
                }
        }
    }
}
