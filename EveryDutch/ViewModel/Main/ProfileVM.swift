//
//  ProfileVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import UIKit

final class ProfileVM: ProfileVMProtocol {
    
    // typealias ProfileDataCell = (type: ProfileType, detail: String?)
    private var _cellTypesDictionary: [Int: [ProfileTypeCell]] = [:]
    private let userAPI: UserAPIProtocol
    
    
    
    // MARK: - 클로저
    var userDataClosure: ((User) -> Void)?
    var errorClosure: ((ErrorEnum) -> Void)?
    
    
    
    private var currentUserData: User? {
        didSet {
            // 클로저를 통해 화면 업데이트
            guard let userData = self.currentUserData else { return }
            self.userDataClosure?(userData)
        }
    }
    private var uid: String = ""
    var getUserID: String { return self.uid }
    
    
    
    // MARK: - 라이프사이클
    init(userAPI: UserAPIProtocol) {
        self.userAPI = userAPI
    }
    deinit { print("\(#function)-----\(self)") }
    
    
    
    // MARK: - 초기 데이터 설정
    func initializeUserData() {
        Task { await fetchOwnUserData() }
    }
    // 사용자 데이터를 기반으로 섹션별 셀 데이터를 생성하는 메서드
    private func makeCellData(user: User) {
        guard let datas = ProfileVCEnum.allCases.first?.createProviders(user: user) else { return }
        self._cellTypesDictionary = datas
    }
}










// MARK: - 테이블 데이터
extension ProfileVM {
    /// 섹션의 개수
    var getNumOfSection: Int {
        return self._cellTypesDictionary.count
    }
    
    /// 셀의 개수
    func getNumOfCell(section: Int) -> Int {
        return self._cellTypesDictionary[section]?.count ?? 0
    }
    
    /// 푸터뷰 높이
    func getFooterViewHeight(section: Int) -> CGFloat {
        guard let count = self._cellTypesDictionary[section]?.count else { return 3}
        // 셀의 개수에 따른 높이
        return count < 3
        ? 50 // 3개 미만이면 == 50
        : 3 // 3개 이상이면 == 3
    }
    
    /// 헤더뷰의 타이틀
    func getHeaderTitle(section: Int) -> String? {
        return self._cellTypesDictionary[section]?.first?.type.headerTitle
    }
    
    /// 셀의 데이터 반환
    func getCellData(indexPath: IndexPath) -> ProfileTypeCell? {
        return self._cellTypesDictionary[indexPath.section]?[indexPath.row]
    }
}










// MARK: - 인덱스패스 리턴
extension ProfileVM {
    /// 특정 타입의 셀 IndexPath 반환
    /// 이 함수는 제네릭 타입 T를 사용하여, 주어진 타입의 셀의 IndexPath를 찾아 반환해준다.
    /// - Parameters:
    ///   - cellType: 찾고자 하는 셀의 타입 (T)
    ///   - section: 섹션을 나타내는 ProfileVCEnum
    /// - Returns: 주어진 타입의 셀 IndexPath를 반환, 없으면 nil
    private func getCellIndexPath<T: ProfileCellType & RawRepresentable>(
        for cellType: T,
        in section: ProfileVCEnum
    ) -> IndexPath? where T.RawValue == Int {
        // 섹션 인덱스에 해당하는 셀이 존재하는지 확인
        guard let cells = _cellTypesDictionary[section.sectionIndex] else { return nil }
        // 셀들을 순회하면서 주어진 타입의 셀을 찾음
        for (index, cell) in cells.enumerated() {
            // 셀 타입을 T로 캐스팅하고, 주어진 타입과 일치하는지 확인
            if let specificType = cell.type as? T, specificType == cellType {
                // 일치하면 해당 셀의 IndexPath 반환
                return IndexPath(row: index, section: section.sectionIndex)
            }
        }
        // 찾지 못하면 nil 반환
        return nil
    }
    
    // UserInfoType.profileImage에 해당하는 셀의 IndexPath를 반환
    var profileImageCellIndexPath: IndexPath? {
        return self.getCellIndexPath(for: UserInfoType.profileImage, in: .userInfo)
    }

    // UserInfoType.personalID에 해당하는 셀의 IndexPath를 반환
    var personalIDCellIndexPath: IndexPath? {
        return self.getCellIndexPath(for: UserInfoType.personalID, in: .userInfo)
    }

    // UserInfoType.nickName에 해당하는 셀의 IndexPath를 반환
    var nickNameCellIndexPath: IndexPath? {
        return self.getCellIndexPath(for: UserInfoType.nickName, in: .userInfo)
    }
}










// MARK: - API
extension ProfileVM {
    /// 유저 데이터 가져오기
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
    
    func saveProfileImage(_ image: UIImage) {
        Task {
            do {
                let imageUrl = try await self.userAPI.uploadProfileImage(image)
                
                try await self.userAPI.updateUserProfileImage(imageUrl: imageUrl)
                print("\(#function) ----- Success")
            } catch {
                print("\(#function) ----- Fail")
            }
        }
    }
}
