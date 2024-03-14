//
//  FindFriendsVM.swift
//  EveryDutch
//
//  Created by 계은성 on 3/14/24.
//

import Foundation

final class FindFriendsVM: FindFriendsVMProtocol {
    
    private let userAPI: UserAPIProtocol
    
    
    var searchSuccessClosure: ((User) -> Void)?
    var searchFailedClosure: (() -> Void)?
    
    
    init(userAPI: UserAPIProtocol) {
        self.userAPI = userAPI
    }
    
    func searchUser(text: String?) {
        //
        guard let userID = text, !userID.isEmpty else {
            // 빈킨이거나, 작성하면 안 되는 기호가 있을 때
            self.searchFailedClosure?()
            return
        }
        
        self.userAPI.searchUser(userID) { [weak self] result in
            switch result {
                // 검색 성공
            case .success(let user):
                dump(user)
                self?.searchSuccessClosure?(user)
                // 검색 실패.
            case .failure(_):
                print("검색 실패")
                self?.searchFailedClosure?()
            }
        }
    }
}

