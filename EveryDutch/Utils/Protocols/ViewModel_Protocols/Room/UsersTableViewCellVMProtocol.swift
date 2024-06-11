//
//  UsersTableViewCellVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/14/24.
//

import UIKit
protocol ReceiptWriteCellVMProtocol {
}

protocol UsersTableViewCellVMProtocol: ReceiptWriteCellVMProtocol {
    
    var cumulativeAmount: Int { get }
    var customTableEnum: UsersTableEnum { get }
    
    var profileImg: UIImage? { get }
    
    var rightBtnImg: UIImage? { get }
    var paybackPrice: Int { get }
    
    
    
    var isButtonExist: Bool { get }
    var imgLeftAnchor: CGFloat { get }
    
    
    var getUserName: String { get }
    
    var userID: String { get }
    
     
    
    mutating func updateUserData(_ user: [String: Any]) -> User?
    
    mutating func setCumulativeAmount(_ amount: Int)
    mutating func setPayback(_ amount: Int)
    
    
    
    
    
    /// 가격 레이블 형식 설정
    /// '10000' -> '10,000원' 으로 바꾸기
    func configureLblFormat(price: String) -> String?
    /// 가격이 변하면, 텍스트필드 형식을 유지하며 변환
    /// '10,000원' -> '15,000원' 으로 바꾸기
    func configureTfFormat(text: String?) -> String?
    
    /// 가격 텍스트필드 형식 제거
    /// '10,000원' -> '10000' 으로 바꾸기
    func removeFormat(text: String?) -> String
    /// 0원인지 확인하는 메서드
    func textIsZero(text: String?) -> String?
    /// 가격 텍스트필드의 alpha값을 설정
    func priceTFAlpha(isSelected: Bool) -> CGFloat
}

