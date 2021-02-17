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
    
    func log(_ nameFunction: String, in state: UIApplication.State) {
        DLogger.shared.logLC(nameFunction, state)
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
    
    func logLC(_ nameFunction: String, _ state: UIApplication.State) {
        switch state {
        case .active:
            toState = "active"
        case .background:
            toState = "background"
        case .inactive:
            toState = "inactive"
        @unknown default:
            break
        }
        
        log("Application moved from \(fromState) to \(toState): \(nameFunction)")
        
        fromState = toState
    }
}
