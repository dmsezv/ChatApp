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
    
    func logLyfeCycleWith(_ nameFunction: String) {
        DLogger.shared.logLC(nameFunction)
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
    
    
    //MARK: - log life cycle
    
    private var fromState: String = "not running"
    private var toState: String = ""
    
    func logLC(_ nameFunction: String) {
        switch UIApplication.shared.applicationState {
        case .active:
            toState = "active"
        case .background:
            toState = "background"
        case .inactive:
            toState = "inactive"
        @unknown default:
            break
        }
        
        #if DEBUG_PRINT_ENABLE
        print("Application moved from \(fromState) to \(toState): \(nameFunction)")
        #endif
        
        fromState = toState
    }
}
