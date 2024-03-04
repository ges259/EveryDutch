//
//  ReceiptWirteVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/06.
//

import UIKit

protocol ReceiptWriteVMProtocol {
    var getSectionCount: Int { get }
    
    var getNumOfReceiptEnum: Int { get }
    
    func getReceiptEnum(index: Int) -> ReceiptEnum
    
    func getFooterViewHeight(section: Int) -> CGFloat
    var getNoDataViewIsHidden: Bool { get }
    var dutchBtnBackgroundColor: UIColor { get }
    
    
    
    func getHeaderTitle(section: Int) -> String
    
    
    var getTimeCellIndexPath: IndexPath { get }
    var getPayerCellIndexPath: IndexPath { get }
    
    var getPriceCellIndexPath: IndexPath { get }
    
    var getMemoCellIndexPath: IndexPath { get }
    
    
    
    func isFistCell(_ receiptEnum: ReceiptEnum) -> Bool
    func isLastCell(_ receiptEnum: ReceiptEnum) -> Bool
    
    func saveCalenderDate(date: Date)
    var getDateCellIndexPath: IndexPath { get }
    
    
    // MARK: - 모델
    var date: Int { get set }
    var time: String { get set }
    var memo: String? { get set }
    var price: Int? { get set }
    var payer: RoomUserDataDict? { get }
    var selectedUsers: RoomUserDataDict { get set }
    
    
    
    // MARK: - 디바운싱
    /// 디바운싱 클로저
    var debouncingClosure: (() -> Void)? { get set }
    /// 테이블뷰가 수정중인지 여부
    var isUserDataTableEditing: Bool { get }
    
    /// 디바운싱 멈추기
    func setDebouncing()
    /// 디바운싱 시작
    func stopDebouncing()
    
    
    
    // MARK: - 테이블뷰
    /// 선택된 유저의 수
    var numOfUsers: Int { get }
    /// 테이블뷰를 숨길지 말지 설정
    var tableIsHidden: Bool { get }
    
    
    // MARK: - 누적 금액
    /// 누적 금액 클로저
    var calculatePriceClosure: ((String?) -> Void)? { get set }
    
    
    
    // MARK: - 더치 버튼
    /// 더치 버튼 클로저
    var dutchBtnClosure: (() -> Void)? { get set }
    /// 현재 더치 버튼이 눌렸는지 확인
    var isDutchedMode: Bool { get set }
    /// 더치 버튼을 눌렀을 때, 셀에 표시 될 가격
    var dutchedPrice: Int { get }
    
    /// 더치 버튼이 눌렸을 때,
    func dutchBtnTapped()
    
    
    // MARK: - 기타
    /// 키보드 높이
    var keyboardHeight: CGFloat { get set }
    
    
    
    
    
    // MARK: - 가격 설정
    func calculatePrice(userID: String, price: Int?)
    
    
    
    // MARK: - 가격 텍스트필드
    // [형식]
////    func savePriceText(text: String?)
    func savePriceText(price: Int)
//    
//    func removeWonFormat(priceText: String?) -> String?
//    func formatPriceForEditing(_ newText: String?) -> String?
//    var priceInfoTFText: String? { get }
    var moneyCountLblText: String? { get }
//    
    
    
    
    // MARK: - 타임 피커
    func timePickerString(hour: Int, minute: Int) -> String
    func timePickerFormat(_ row: Int) -> String
    func getCurrentTime() -> [Int]
    
    
    
    // MARK: - 레시피 체크
    var receiptDict: [String : Any?] { get }
    
    
//    func getCheckReceipt(completion: @escaping (Bool) -> Void)
//    func prepareReceiptDataAndValidate(completion: @escaping (Bool, [String: Any?]) -> Void)
    func prepareReceiptDataAndValidate(completion: @escaping Typealias.ValidationCompletion) 
    
// MARK: - [여러명] paymentDetails 선택
    
    
    
    // MARK: - 유저 추가
    func createUsersCellVM(addedUsers: RoomUserDataDict)
    func indexPathsForAddedUsers(_ users: RoomUserDataDict) -> [IndexPath]
    
    
    // MARK: - 유저 삭제
    func deleteData(removedUsers: RoomUserDataDict)
    func indexPathsForRemovedUsers(_ users: RoomUserDataDict) -> [IndexPath]
    func deleteCellVM(userID: String?)
    
    
    
    
    
// MARK: - [1명] payer 선택
    
    
    
    // MARK: - 선택된 유저의 이름
    func isPayerSelected(selectedUser: RoomUserDataDict)
    
    
    var getSelectedUsers: String? { get }
    
    
// MARK: - 셀의 뷰모델 반환
    func usersCellViewModel(at index: Int) -> ReceiptWriteUsersCellVM
}
