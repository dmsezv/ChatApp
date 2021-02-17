//
//  DLogger.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 16.02.2021.
//

import Foundation
import UIKit

protocol DLogging {}

extension DLogging {
    func log(_ message: String) {
        DLogger.shared.log(message)
    }
    
    func logLC(_ function: String) {
        var fromState = ""
        var toState = ""
        switch UIApplication.shared.applicationState {
        case .active:
            toState = "active"
        case .background:
            toState = "background"
        case .inactive:
            toState = "background"
        @unknown default:
            break
        }
        
        DLogger.shared.log("Application moved from ??? to \(toState): \(function)")
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
