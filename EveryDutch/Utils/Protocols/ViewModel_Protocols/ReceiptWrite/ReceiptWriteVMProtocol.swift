//
//  ReceiptWirteVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

protocol ReceiptWriteVMProtocol {
    // MARK: - 클로저
    /// 디바운싱 클로저
    var debouncingClosure: (() -> Void)? { get set }
    /// 더치 버튼 클로저
    var dutchBtnClosure: (() -> Void)? { get set }
    /// 누적 금액 클로저
    var calculatePriceClosure: ((String?) -> Void)? { get set }
    
    var errorClosure: ((ErrorEnum) -> Void)?  { get set }
    var successMakeReceiptClosure: (() -> Void)? { get set }
    
    
    
    
    
    // MARK: - 데이터
    var payer: RoomUserDataDict { get }
    var selectedUsers: RoomUserDataDict { get }
    /// 키보드 높이
    var keyboardHeight: CGFloat { get set }
    /// 더치 버튼을 눌렀을 때, 셀에 표시 될 가격
    var dutchedPrice: Int { get }
    /// 현재 더치 버튼이 눌렸는지 확인
    var isDutchedMode: Bool { get set }
    /// 테이블뷰가 수정중인지 여부
    var isUserDataTableEditing: Bool { get }
    
    
    
    
    
    // MARK: - 테이블뷰
    /// 섹션의 타입을 리턴
    func setSectionIndex(section: Int) -> ReceiptWriteEnum?
    var getSectionCount: Int { get }
    func getNumOfCell(section: Int) -> Int
    func getHeaderTitle(section: Int) -> String
    func isLastCell(row: Int) -> Bool
    
    
    
    
    
    // MARK: - 셀 업데이트 시
    func findReceiptEnumIndex(_ receiptEnum: ReceiptCellEnum) -> IndexPath
    var getNoDataViewIsHidden: Bool { get }
    
    
    
    
    
    // MARK: - 셀의 데이터 반환
    var moneyCountLblText: String? { get }
    var getSelectedUsers: String? { get }
    
    
    
    
    
    // MARK: - 데이터 저장
    func saveCalenderDate(date: Date)
    func saveTime(time: String)
    func saveMemo(context: String)
    func savePriceText(price: Int)
    func isPayerSelected(selectedUser: RoomUserDataDict)
    
    
    
    // MARK: - 푸터뷰
    func getFooterViewHeight(section: Int) -> CGFloat
    var dutchBtnBackgroundColor: UIColor { get }
    
    
    
    
    
    // MARK: - 셀의 뷰모델 생성
    func createUsersCellVM(
        addedUsers: RoomUserDataDict)
    
    // MARK: - 셀 뷰모델 반환
    func getDataCellViewModel(indexPath: IndexPath) -> ReceiptWriteDataCellVMProtocol?
    func getUserCellViewModel(indexPath: IndexPath) -> UsersTableViewCellVMProtocol?
    
    
    
    
    
    // MARK: - 계산할 사람 선택
    /// 추가될 셀의 IndexPath
    func indexPathsForAddedUsers(_ users: RoomUserDataDict) -> [IndexPath]
    /// 유저 뷰모델 삭제
    func deleteData(removedUsers: RoomUserDataDict)
    /// 삭제 될 셀의 IndexPath
    func indexPathsForRemovedUsers(_ users: RoomUserDataDict) -> [IndexPath]
    
    
    
    
    
    // MARK: - 가격 설정
    func calculatePrice(userID: String, price: Int?)
    /// 더치 버튼이 눌렸을 때,
    func dutchBtnTapped()
    
    
    
    
    
    // MARK: - 디바운싱
    /// 디바운싱 멈추기
    func setDebouncing()
    /// 디바운싱 시작
    func stopDebouncing()
    
    
    
    
    
    // MARK: - 유효성 검사
    func validationData()
}
