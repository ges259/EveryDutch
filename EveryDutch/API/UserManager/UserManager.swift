//
//  UserManager.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit



final class RoomDataManager: RoomDataManagerProtocol {
    static let shared: RoomDataManagerProtocol = RoomDataManager(
        roomsAPI: RoomsAPI.shared)
    
    
    private var roomsAPI: RoomsAPIProtocol
    
    
    // MARK: - 라이프사이클
    init(roomsAPI: RoomsAPIProtocol) {
        self.roomsAPI = roomsAPI
    }
    deinit { print("\(#function)-----\(self)") }
    
    
    
    /// roomID / versionID / roomNam / roomImg
    private var currentRoomData: Rooms?
    
    
    private var rooms: [Rooms]?
//    private var currentIndex: Int = 0
    
    
    private var cumulativeAmount: CumulativeAmountDictionary = [:]
    private var paybackData: Payback?
    
    
    
    
    
    
    /// [userID : User]로 이루어진 딕셔너리
    /// Receipt관련 화면에서 userID로 User의 데이터 사용
    /// ReceiptWriteVC에서 유저의 정보 사용
    private var roomUserDataDict: [String : User] = [:]
    
    // UsersTableViewCell 관련 프로퍼티들
    private var userIDToIndexPathMap: [String: IndexPath] = [:]
    private var cellViewModels: [UsersTableViewCellVMProtocol] = []
    


    // 두 작업 완료 여부를 추적하는 플래그
    // 플래그 대신 상태 추적을 위한 집합 사용
    private var loadedStates: Set<String> = []
    private let cumulativeAmountLoadedKey = "cumulativeAmount"
    private let paybackLoadedKey = "payback"
    private var changedIndexPaths: [IndexPath] = []


    
    
    
    
    
// MARK: - 유저 테이블
    
    
    
    // MARK: - 방의 개수
    var getNumOfRoomUsers: Int {
        return self.cellViewModels.count
    }
    
    
    // MARK: - 뷰모델 리턴
    func getViewModel(index: Int) -> UsersTableViewCellVMProtocol {
        return self.cellViewModels[index]
    }
    
    
    
// MARK: - 특정 유저 정보 리턴
    
    var getRoomUsersDict: RoomUserDataDict {
        return self.roomUserDataDict
    }
    
    /// 인데스패스 리턴
    func getUserIndexPath(userID: String) -> IndexPath? {
        return self.userIDToIndexPathMap[userID]
    }
    
    /// 누적 금액 리턴
    func getIDToCumulativeAmount(userID: String) -> Int {
        return self.cumulativeAmount[userID]?.cumulativeAmount ?? 0
    }
    
    /// 페이백 값
    func getIDToPayback(userID: String) -> Int {
        return self.paybackData?.payback[userID] ?? 0
    }
    
    /// Receipt가 필요한 화면에서 userID로 User의 정보를 알기 위해 사용
    func getIdToRoomUser(usersID: String) -> User {
        return self.roomUserDataDict[usersID]
        ?? User(dictionary: [:])
    }
    
    
    
    
    
    
// MARK: - 현재 방 정보

    
    
    // MARK: - 방 데이터 가져가기
    var getRooms: [Rooms] {
        guard let rooms = self.rooms else { return [] }
        return rooms
    }
    
    // MARK: - 방 데이터 추가
    func addedRoom(room: Rooms) {
        self.rooms?.insert(room, at: 0)
    }
    
    // MARK: - 선택된 현재 방 저장
    func saveCurrentRooms(index: Int) {
        self.currentRoomData = self.rooms?[index]
    }
    
    // MARK: - 방의 이름
    var getCurrentRoomName: String? {
        return self.currentRoomData?.roomID
    }
    
    // MARK: - 방 ID
    var getCurrentRoomsID: String? {
        return self.currentRoomData?.roomID
    }
    
    // MARK: - 버전 ID
    var getCurrentVersion: String? {
        return self.currentRoomData?.versionID
    }
}










// MARK: - [API]

extension RoomDataManager {
    
    
    // MARK: - 방의 데이터
    @MainActor
    func loadRooms(completion: @escaping Typealias.VoidCompletion) {
        Task {
            do {
                let rooms = try await self.roomsAPI.readRooms()
                self.rooms = rooms
                completion(.success(()))
                
            } catch {
                completion(.failure(.readError))
            }
        }
    }
}















extension RoomDataManager {
    
    // MARK: - 유저 데이터
    // 콜백 함수 만들기(completion)
    // SettlementMoneyRoomVM에서 호출 됨
    func loadRoomUsers(completion: @escaping (Result<Void, ErrorEnum>) -> Void) {
        // roomData 저장
        guard let roomID = self.currentRoomData?.roomID else { return }
        
        // 데이터베이스나 네트워크에서 RoomUser 데이터를 가져오는 로직
        self.roomsAPI.readRoomUsers(roomID: roomID) { [weak self] result in
            switch result {
            case .success(let users):
                print("users 성공")
                // [String : RoomUsers] 딕셔너리 저장
                self?.updateUsers(with: users)
                completion(.success(()))
                break
                
            case .failure(let errorEnum):
                print("users 실패")
                completion(.failure(errorEnum))
                break
            }
        }
    }
    
    
    private func updateUsers(with usersEvent: UserEvent) {
        
        switch usersEvent {
        case .updated(let toUpdate):
            // 리턴할 인덱스패스
            var updatedIndexPaths = [IndexPath]()
            
            for (userID, user) in toUpdate {
                if let indexPath = self.userIDToIndexPathMap[userID] {
                    // 뷰모델에 바뀐 user데이터 저장
                    self.cellViewModels[indexPath.row].updateUserData(user)
                    // [userID: User] 딕셔너리 데이터 업데이트
                    self.roomUserDataDict[userID] = user
                    updatedIndexPaths.append(indexPath)
                }
            }
            
            self.postNotification(name: .userDataChanged,
                                  eventType: .updated(toUpdate),
                                  indexPath: updatedIndexPaths)
            
            
            // 데이터 초기 로드
        case .initialLoad(let userDict):
            // 리턴할 인덱스패스
            var addedIndexPaths = [IndexPath]()

            // 초기 로드일 때 모든 데이터 초기화
            self.cellViewModels.removeAll()
            self.userIDToIndexPathMap.removeAll()
            // [userID: User] 딕셔너리 데이터 저장
            self.roomUserDataDict = userDict
            
            // 모든 데이터 추가
            for (index, (userID, user)) in userDict.enumerated() {
                // 인덱스 패스 생성
                let indexPath = IndexPath(row: index, section: 0)
                // 뷰모델 생성
                let viewModel = UsersTableViewCellVM(
                    userID: userID,
                    roomUsers: user,
                    customTableEnum: .isSettleMoney)
                // 뷰모델 저장
                self.cellViewModels.append(viewModel)
                // 인덱스패스 저장
                self.userIDToIndexPathMap[userID] = indexPath
                addedIndexPaths.append(indexPath)
            }
            
            self.postNotification(name: .userDataChanged,
                                  eventType: .initialLoad(userDict),
                                  indexPath: addedIndexPaths)
            
            
        case .added(let toAdd):
            // 리턴할 인덱스패스
            var addedIndexPaths = [IndexPath]()
            for (userID, user) in toAdd {
                // 중복 추가 방지
                guard self.userIDToIndexPathMap[userID] == nil else { continue }
                // 인덱스패스 생성
                let indexPath = IndexPath(row: self.cellViewModels.count, section: 0)
                // 뷰모델 생성
                let viewModel = UsersTableViewCellVM(
                    userID: userID,
                    roomUsers: user,
                    customTableEnum: .isSettleMoney)
                // 뷰모델 저장
                self.cellViewModels.append(viewModel)
                // 인덱스패스 업데이트
                self.userIDToIndexPathMap[userID] = indexPath
                // [userID: User] 딕셔너리 데이터 업데이트
                self.roomUserDataDict[userID] = user
                addedIndexPaths.append(indexPath)
            }
            
            self.postNotification(name: .userDataChanged,
                                  eventType: .added(toAdd),
                                  indexPath: addedIndexPaths)
            
            
        case .removed(let userID):
            // 리턴할 인덱스패스
            var removedIndexPaths = [IndexPath]()

            if let indexPath = self.userIDToIndexPathMap[userID] {
                // 뷰모델 삭제
                self.cellViewModels.remove(at: indexPath.row)
                // 인덱스패스 삭제
                self.userIDToIndexPathMap.removeValue(forKey: userID)
                // [String: User] 데이터 삭제
                self.roomUserDataDict.removeValue(forKey: userID)
                removedIndexPaths.append(indexPath)
                // 삭제 후 인덱스 재정렬 (인덱스 매핑 최적화)
                for row in indexPath.row..<self.cellViewModels.count {
                    let newIndexPath = IndexPath(row: row, section: 0)
                    let userID = self.cellViewModels[row].userID
                    self.userIDToIndexPathMap[userID] = newIndexPath
                }
            }
            self.postNotification(name: .userDataChanged,
                                  eventType: .removed(userID),
                                  indexPath: removedIndexPaths)
        }
    }
    
    private func postNotification(
        name: Notification.Name,
        eventType: UserEvent,
        indexPath: [IndexPath])
    {
        // 노티피케이션 전송
        NotificationCenter.default.post(
            name: .userDataChanged,
            object: nil,
            userInfo: [eventType.notificationName: indexPath]
        )
    }
}






















extension RoomDataManager {
    // 두 데이터 로드 작업을 실행하고 모두 완료되면 콜백을 호출
    func loadFinancialData() {
        guard let versionID = self.getCurrentVersion else { return }
        self.resetMoneyData()
        self.loadCumulativeAmountData(versionID: versionID)
        self.loadPaybackData(versionID: versionID)
    }

    // MARK: - 누적 금액 데이터
    private func loadCumulativeAmountData(versionID: String) {
        self.roomsAPI.readCumulativeAmount(versionID: versionID) { [weak self] result in
            switch result {
            case .success(let moneyData):
                print("cumulativeMoney 성공")
                dump(moneyData)
                self?.updateCumulativeAmount(moneyData)
                self?.markAsLoaded(self?.cumulativeAmountLoadedKey ?? "")
                self?.trySendNotification()
                break
            case .failure:
                print("cumulativeMoney 실패")
                break
            }
        }
    }

    // MARK: - 페이백 데이터
    private func loadPaybackData(versionID: String) {
        self.roomsAPI.readPayback(versionID: versionID) { [weak self] result in
            switch result {
            case .success(let moneyData):
                print("payback 성공")
                dump(moneyData)
                self?.updatePayback(moneyData)
                self?.markAsLoaded(self?.paybackLoadedKey ?? "")
                self?.trySendNotification()
                break
                
            case .failure:
                print("payback 실패")
                break
            }
        }
    }

    // 누적 금액 데이터 변경
    private func updateCumulativeAmount(_ amount: [String: Int]) {
        for (key, value) in amount {
            guard let indexPath = self.userIDToIndexPathMap[key] else {
                print("User not found in the mapping.")
                continue
            }
            let index = indexPath.row
            if index < self.cellViewModels.count {
                self.cellViewModels[index].setCumulativeAmount(value)
                self.changedIndexPaths.append(indexPath)
            }
        }
    }

    // 페이백 데이터 변경
    private func updatePayback(_ payback: [String: Int]) {
        for (key, value) in payback {
            guard let indexPath = self.userIDToIndexPathMap[key] else {
                print("User not found in the mapping.")
                continue
            }
            let index = indexPath.row
            if index < self.cellViewModels.count {
                self.cellViewModels[index].setpayback(value)
                self.changedIndexPaths.append(indexPath)
            }
        }
    }

    
    
    // 상태 추적용 마킹 함수
    private func markAsLoaded(_ key: String) {
        self.loadedStates.insert(key)
    }
    
    // 모든 데이터 로드 완료 여부 확인
    private func allDataLoaded() -> Bool {
        return self.loadedStates.contains(cumulativeAmountLoadedKey) && self.loadedStates.contains(paybackLoadedKey)
    }
    // 모든 데이터가 로드되었는지 확인하고 노티피케이션 전송
    private func trySendNotification() {
//        if self.allDataLoaded() {
            print(#function)
            print(self.changedIndexPaths)
            print(self.changedIndexPaths.count)
            print("____________")
            NotificationCenter.default.post(
                name: .financialDataUpdated,
                object: nil,
                userInfo: ["updated": self.changedIndexPaths]
            )
            // 모든 데이터가 로드되었으므로 상태 초기화
            self.resetMoneyData()
//        }
    }
    
    private func resetMoneyData() {
        self.loadedStates = []
        self.changedIndexPaths = []
    }
}
