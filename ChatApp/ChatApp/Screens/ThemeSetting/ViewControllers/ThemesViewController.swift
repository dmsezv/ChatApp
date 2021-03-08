//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 08.03.2021.
//

import UIKit

class ThemesViewController: UIViewController {
    
    @IBAction func touchButtonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
    }
}
