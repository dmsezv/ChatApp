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
    
    func log(_ function: String, from: String, to: String) {
        DLogger.shared.log("Application moved from \(from) to \(to): \(function)")
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
