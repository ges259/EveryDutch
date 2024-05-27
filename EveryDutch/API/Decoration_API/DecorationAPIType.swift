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
    func fetchDecoration(dataRequiredWhenInEditMode: String?) async throws -> Decoration? {
        guard let dataRequiredWhenInEidtMode = dataRequiredWhenInEditMode else {
            throw ErrorEnum.readError
        }
        
        return try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Decoration?, Error>) in
            self.fetchDecoration(with: dataRequiredWhenInEidtMode) { result in
                switch result {
                case .success(let deco):
                    continuation.resume(returning: deco)
                case .failure(_):
                    continuation.resume(throwing: ErrorEnum.readError)
                }
            }
        }
    }

    private func fetchDecoration(
        with id: String,
        completion: @escaping (Result<Decoration?, ErrorEnum>) -> Void)
    {
        CARD_DECORATION_REF
            .child(id)
            .observeSingleEvent(of: .value) { snapshot in
                guard snapshot.exists() else {
                    completion(.success(nil))
                    return
                }
                guard let value = snapshot.value as? [String: Any] else {
                    completion(.failure(.readError))
                    return
                }
                let decoration = Decoration(dictionary: value)
                completion(.success(decoration))
            }
    }
    
    func fetchAllDecorations(
        IDs: [String],
        completion: @escaping (Result<DataChangeEvent<[String: Decoration?]>, ErrorEnum>) -> Void)
    {
        var decoDictionary = [String: Decoration?]()
        let dictionaryQueue = DispatchQueue(label: "com.yourapp.decoDictionaryQueue", attributes: .concurrent)
        let saveGroup = DispatchGroup()
        
        for id in IDs {
            saveGroup.enter()
            self.fetchDecoration(with: id) { result in
                dictionaryQueue.async(flags: .barrier) {
                    switch result {
                    case .success(let deco):
                        decoDictionary[id] = deco
                    case .failure(_):
                        decoDictionary[id] = nil
                    }
                    saveGroup.leave()
                }
            }
        }
        
        saveGroup.notify(queue: .main) {
            completion(.success(.initialLoad(decoDictionary)))
        }
    }
    
    func observeDecorations(
        IDs: [String],
        completion: @escaping (Result<DataChangeEvent<[String: Decoration?]>, ErrorEnum>) -> Void)
    {
        let group = DispatchGroup()
        var results = [String: [String: Any]]()
        let dictionaryQueue = DispatchQueue(label: "com.yourapp.dictionaryQueue", attributes: .concurrent)
        var observedError: ErrorEnum?

        for id in IDs {
            group.enter()
            let userPath = CARD_DECORATION_REF.child(id)
            
            userPath.observe(.childChanged) { snapshot in
                dictionaryQueue.async(flags: .barrier) {
                    guard let valueData = snapshot.value else {
                        observedError = .readError
                        group.leave()
                        return
                    }
                    
                    let dict = [snapshot.key: valueData]
                    results[id] = dict
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            if let error = observedError {
                completion(.failure(error))
            } else {
                completion(.success(.updated(results)))
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
            CARD_DECORATION_REF
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
