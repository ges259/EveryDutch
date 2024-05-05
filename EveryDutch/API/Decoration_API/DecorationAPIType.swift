//
//  DecorationAPIType.swift
//  EveryDutch
//
//  Created by 계은성 on 3/30/24.
//

import UIKit
import FirebaseStorage

protocol DecorationAPIType {}

extension DecorationAPIType {
    
    // MARK: - 이미지 저장
    func uploadImage(data: [String: UIImage]) async throws -> [String: String] {
        var urlDict = [String: String]()
        for (key, image) in data {
            let uploadURL = try await self.uploadImageAndGetURL(key: key, image: image)
            urlDict[key] = uploadURL
        }
        return urlDict
    }
    
    private func uploadImageAndGetURL(key: String, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageConversionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to convert UIImage to JPEG data"])
        }
        let storageRef = Storage.storage().reference().child("images/\(key).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<String, Error>) in
            
            let uploadTask = storageRef.putData(imageData, metadata: metadata)
            uploadTask.observe(.success) { snapshot in
                storageRef.downloadURL { url, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let url = url {
                        continuation.resume(returning: url.absoluteString)
                    }
                }
            }
            
            uploadTask.observe(.failure) { snapshot in
                if let error = snapshot.error {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    
    // MARK: - 데코레이션 가져오기
    func fetchDecoration(dataRequiredWhenInEidtMode: String?) async throws -> Decoration? {
        guard let dataRequiredWhenInEidtMode = dataRequiredWhenInEidtMode else {
            throw ErrorEnum.readError
        }
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Decoration?, Error>) in
            
            CARD_DATA_REF
                .child(dataRequiredWhenInEidtMode)
                .observeSingleEvent(of: .value) { snapshot in
                    
                    guard snapshot.exists() else {
                        // 스냅샷에 데이터가 존재하지 않는 경우, 기본 Decoration 객체 반환
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
    
    
    
    // MARK: - 데코레이션 업데이트
    func updateDecoration(
        at ref: String?,
        with dict: [String: Any?]
    ) async throws {
        
        guard let ref = ref else { throw ErrorEnum.readError }
        let decorationDict = dict.compactMapValues { $0 }
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            CARD_DATA_REF
                .child(ref)
                .updateChildValues(decorationDict) { error, _ in
                    if let _ = error {
                        continuation.resume(throwing: ErrorEnum.unknownError)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
        }
    }
}
