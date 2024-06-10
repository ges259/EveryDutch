//
//  DecorationAPIType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/30/24.
//

import UIKit
import FirebaseStorage

protocol DecorationAPI {}

extension DecorationAPI {
    // MARK: - 데코레이션 가져오기
    func fetchDecoration(dataRequiredWhenInEditMode: String?) async throws -> Decoration? {
        guard let decoID = dataRequiredWhenInEditMode else {
            throw ErrorEnum.readError
        }
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Decoration?, Error>) in
            CARD_DECORATION_REF
                .child(decoID)
                .observeSingleEvent(of: .value) { snapshot in
                    guard snapshot.exists() else {
                        continuation.resume(returning: nil)
                        return
                    }
                    guard let value = snapshot.value as? [String: Any] else {
                        continuation.resume(throwing: ErrorEnum.readError)
                        return
                    }
                    let decoration = Decoration(dictionary: value)
                    continuation.resume(returning: decoration)
                }
        }
    }
    
    
    
    // MARK: - 옵저버 설정
    func observeDecorations(
        IDs: [String],
        completion: @escaping (Result<DataChangeEvent<[String: Decoration?]>, ErrorEnum>) -> Void)
    {
        for id in IDs {
            let userPath = CARD_DECORATION_REF.child(id)
            
            // 전체 데이터를 가져오는 .value 이벤트
            userPath.observe(.value) { snapshot in
                
                if snapshot.exists() {
                    guard let valueData = snapshot.value as? [String: Any] else {
                        print("Failed to parse snapshot value as dictionary for ID: \(id)")
                        completion(.failure(.readError))
                        return
                    }
                    let decoration = Decoration(dictionary: valueData)
                    print("\(#function) ----- Success")
                    dump(decoration)
                    completion(.success(.added([id: decoration])))
                } else {
                    // 스냅샷이 존재하지 않으면 빈 딕셔너리 리턴
                    print("\(#function) ----- Error")
                }
            }
            
            // 데이터가 삭제될 때를 감지하는 .childRemoved 이벤트
            userPath.observe(.childRemoved) { snapshot in
                completion(.success(.removed(id)))
            }
        }
    }
}
