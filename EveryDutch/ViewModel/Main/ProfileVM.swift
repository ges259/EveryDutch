//
//  ProfileVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import UIKit

final class ProfileVM: ProfileVMProtocol {
    
    private let section: [ProfileVCEnum] = ProfileVCEnum.allCases
    
    
    
    // MARK: - 섹션의 개수
    var getNumOfSection: Int {
        return self.section.count
    }
    
    private var currentUserData: User? {
        didSet {
            // `currentUserData`의 값 중 하나를 선택하여 사용합니다.
            // 예를 들어, 딕셔너리의 첫 번째 값을 사용할 수 있습니다.
            guard let userData = self.currentUserData else { return }
            self.userDataClosure?(userData)
            
        }
    }
    
    
    var userDataClosure: ((User) -> Void)?
    var errorClosure: ((ErrorEnum) -> Void)?
    
    
    
    
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
    
    
    
    
    
    
    
    
    
    
    // MARK: - 헤더의 타이틀
    func getHeaderTitle(section: Int) -> String {
        return self.section[section].headerTitle
    }
    
    // MARK: - 푸터뷰 높이
    func getFooterViewHeight(section: Int) -> CGFloat {
        let tableData = self.section[section].cellTitle
        let count = tableData.count
        
        return count < 3 ? 50 : 5
    }
    
    // MARK: - 섹션 당 셀의 개수
    func getNumOfCell(section: Int) -> Int {
        let tableData = self.section[section].cellTitle
        return tableData.count
    }
    
    // MARK: - 테이블 Info 데이터
    func getTableData(section: Int, index: Int) -> String {
        let tableData: [String] = self.section[section].cellTitle
        return tableData[index]
    }
    
    // MARK: - 테이블 detail 데이터
    
}








extension ProfileVM {
    
    @MainActor
    private func fetchOwnUserData() async {
        do {
            let userDict = try await self.userAPI.readYourOwnUserData()
            if let user = userDict.values.first {
                self.currentUserData = user
                
            } else {
                self.errorClosure?(.userNotFound) // 예시 에러 처리
            }
            
        } catch let error as ErrorEnum {
            self.errorClosure?(error)
            
            
        } catch {
            self.errorClosure?(.unknownError)
        }
    }
}
