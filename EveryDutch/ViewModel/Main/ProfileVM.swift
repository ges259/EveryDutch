//
//  ProfileVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import UIKit

final class ProfileVM: ProfileVMProtocol {
    
    // typealias ProfileDataCell = (type: ProfileType, detail: String?)
    private var cellTypesDictionary: [Int: [ProfileTypeCell]] = [:]
    
    
    
    
    private var currentUserData: User? {
        didSet {
            // 클로저를 통해 화면 업데이트
            guard let userData = self.currentUserData else { return }
            self.userDataClosure?(userData)
        }
    }
    
    private var uid: String = ""
    
    
    var getUserID: String {
        return self.uid
    }
    
    // MARK: - 클로저
    var userDataClosure: ((User) -> Void)?
    var errorClosure: ((ErrorEnum) -> Void)?
    
    
    
    // MARK: - API
    private let userAPI: UserAPIProtocol
    
    
    
    
    

    
    
    
    
    // MARK: - 라이프사이클
    init(userAPI: UserAPIProtocol) {
        self.userAPI = userAPI
    }
    deinit { print("\(#function)-----\(self)") }
    
    // MARK: - User 데이터 가져오기
    func initializeUserData() {
        Task { await fetchOwnUserData() }
    }
}










// MARK: - 테이블 데이터
extension ProfileVM {
    /// 섹션의 개수
    var getNumOfSection: Int {
        return self.cellTypesDictionary.count
    }
    
    /// 셀의 개수
    func getNumOfCell(section: Int) -> Int {
        return self.cellTypesDictionary[section]?.count ?? 0
    }
    
    /// 푸터뷰 높이
    func getFooterViewHeight(section: Int) -> CGFloat {
        guard let count = self.cellTypesDictionary[section]?.count else { return 3}
        // 셀의 개수에 따른 높이
        return count < 3
        ? 50 // 3개 미만이면 == 50
        : 3 // 3개 이상이면 == 3
    }
    
    /// 헤더뷰의 타이틀
    func getHeaderTitle(section: Int) -> String? {
        return self.cellTypesDictionary[section]?.first?.type.headerTitle
    }
    
    /// 셀의 데이터 반환
    func getCellData(indexPath: IndexPath) -> ProfileTypeCell? {
        return self.cellTypesDictionary[indexPath.section]?[indexPath.row]
    }
}





    
    
    

// MARK: - 데이터 생성 로직 생성
extension ProfileVM {
    // 사용자 데이터를 기반으로 섹션별 셀 데이터를 생성하는 메서드
    private func makeCellData(user: User) {
        guard let datas = ProfileVCEnum.allCases.first?.createProviders(user: user) else { return }
        self.cellTypesDictionary = datas
    }
}










// MARK: - API

extension ProfileVM {
    
    // MARK: - 유저 데이터 가져오기
    @MainActor
    private func fetchOwnUserData() async {
        do {
            let userDict = try await self.userAPI.readYourOwnUserData()
            if let uid = userDict.keys.first,
                let user = userDict.values.first {
                // 셀 데이터로 저장
                self.makeCellData(user: user)
                
                self.uid = uid
                // 가져온 user데이터 저장하기
                self.currentUserData = user
                
            } else {
                self.errorClosure?(ErrorEnum.userNotFound) // 예시 에러 처리
            }
            
        } catch let error as ErrorEnum {
            self.errorClosure?(error)
            
        } catch {
            self.errorClosure?(ErrorEnum.unknownError)
        }
    }
}
