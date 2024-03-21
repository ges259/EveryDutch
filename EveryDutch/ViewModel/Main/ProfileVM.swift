//
//  ProfileVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import UIKit

final class ProfileVM: ProfileVMProtocol {
    
    
    private var cellTypesDictionary: [Int: [profileType]] = [:]
    
    
    
    
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
        // 섹션 데이터 초기화
        self.initializeSectionData()
    }
    deinit { print("\(#function)-----\(self)") }
    
    // MARK: - 섹션 데이터 초기 설정
    private func initializeSectionData() {
        let sectionData = ProfileVCEnum.allCases
        
        sectionData.forEach { section in
            let sectionIdex = section.sectionIndex
            self.cellTypesDictionary[sectionIdex] = section.getAllOfCellType
        }
    }
    
    // MARK: - User 데이터 가져오기
    func initializeUserData() {
        Task { await fetchOwnUserData() }
    }
}










// MARK: - 테이블 데이터

extension ProfileVM {
    
    // MARK: - 섹션의 개수
    var getNumOfSection: Int {
        return self.cellTypesDictionary.count
    }
    
    // MARK: - 셀의 개수
    func getNumOfCell(section: Int) -> Int {
        return self.cellTypesDictionary[section]?.count ?? 0
    }
    
    // MARK: - 푸터뷰 높이
    func getFooterViewHeight(section: Int) -> CGFloat {
        guard let count = self.cellTypesDictionary[section]?.count else { return 3}
        // 셀의 개수에 따른 높이
        return count < 3
        ? 50 // 3개 미만이면 == 50
        : 3 // 3개 이상이면 == 3
    }
    
    // MARK: - 테이블 Info 데이터
    func getTableData(section: Int, index: Int) -> String? {
        return self.cellTypesDictionary[section]?[index].cellTitle ?? nil
    }
}
    
    
    







// MARK: - 화면 데이터

extension ProfileVM {
        
    // MARK: - 헤더의 타이틀
    func getHeaderTitle(section: Int) -> String? {
        return self.cellTypesDictionary[section]?.first?.headerTitle
    }
}






    
    
    

// MARK: - CellForRowAt

extension ProfileVM {
    
    // MARK: - 타입 반환
    func returnCellType(indexPath: IndexPath) -> profileType? {
        return self.cellTypesDictionary[indexPath.section]?[indexPath.row]
    }
    
    // MARK: - 마지막셀 검사
    // 특정 섹션의 마지막 셀인지 여부를 반환하는 함수
    // indexPath로 주어진 위치가 해당 섹션의 마지막 셀 위치와 일치할 경우 true를 반환
    func getLastCell(indexPath: IndexPath) -> Bool {
        return (self.cellTypesDictionary[indexPath.section]?.count ?? 0) - 1 == indexPath.row
    }
}










// MARK: - API

extension ProfileVM {
    
    // MARK: - 유저 데이터 가져오기
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
