//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var labelInitials: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var viewAvatar: UIView!
    
    let cornRadBtn: CGFloat = 14.0
    let charSpacing: Double = -25.0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //btnEdit is nil because
        if let btnEdit = btnEdit {
            log("\(btnEdit.frame)")
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if let btnEdit = btnEdit {
            log("\(btnEdit.frame)")
        }
    }
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let btnEdit = btnEdit {
            log("\(#function) btnEdit.frame = \(btnEdit.frame)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let btnEdit = btnEdit {
            log("\(#function) btnEdit.frame = \(btnEdit.frame)")
        }
    }
    
    private func setupView() {
        if let labelInitials = labelInitials {
            labelInitials.addCharacterSpacing(kernValue: charSpacing)
        }
        
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
