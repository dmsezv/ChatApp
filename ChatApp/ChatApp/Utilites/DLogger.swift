//
//  DLogger.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 16.02.2021.
//

import Foundation

protocol DLogging {}

extension DLogging {
    func log(_ message: String) {
        DLogger.shared.log(message)
    }
}

fileprivate final class DLogger {
    static let shared = DLogger()
    
    private init() {}
    
    func log(_ message: String) {
        #if DEBUG_PRINT_ENABLE
        print(message)
        #endif
    }
}
