//
//  ViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 13.02.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        log(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        log(#function)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        log(#function)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        log(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        log(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        log(#function)
    }
}
