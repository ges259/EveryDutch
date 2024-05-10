//
//  CrashlyticsLoggable.swift
//  EveryDutch
//
//  Created by 계은성 on 2/20/24.
//

import Foundation
import FirebaseCrashlytics


protocol CrashlyticsLoggable {
    func logError(
        _ error: Error,
        withAdditionalInfo info: [String: Any],
        functionName: String)
}

extension CrashlyticsLoggable {
    func logError(
        _ error: Error,
        withAdditionalInfo info: [String: Any] = [:],
        functionName: String = #function)
    {
        print("Error encountered: \(error.localizedDescription)")
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .long)

        // 기본 오류 메시지 로그
        Crashlytics
            .crashlytics()
            .log("Error in \(functionName): at \(timestamp): \(error.localizedDescription) error: \(error.localizedDescription)")
        
        // 추가 정보 로그
        info.forEach { key, value in
            Crashlytics
                .crashlytics()
                .setCustomValue(value, forKey: key)
        }
    }
}
