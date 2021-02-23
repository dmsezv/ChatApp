//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var viewAvatar: UIView!
    
    let cornRadBtn: CGFloat = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        if let viewAvatar = viewAvatar {
            viewAvatar.clipsToBounds = true
            viewAvatar.layer.cornerRadius = viewAvatar.bounds.height / 2
        }
        
        if let btnEdit = btnEdit {
            btnEdit.clipsToBounds = true
            btnEdit.layer.cornerRadius = cornRadBtn
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
