//
//  SplashScreenVMProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/29/24.
//

import Foundation

protocol SplashScreenVMProtocol {    
    func checkLogin()
    var errorClosure: ((ErrorEnum) -> Void)? { get set }
    var successClosure: (() -> Void)? { get set }
}
