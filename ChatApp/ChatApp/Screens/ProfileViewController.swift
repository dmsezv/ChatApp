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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
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
            viewAvatar.layer.cornerRadius = viewAvatar.bounds.width / 2
            let tap = UITapGestureRecognizer(target: self, action: #selector(addAvatar(_ : )))
            viewAvatar.addGestureRecognizer(tap)
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


//MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerAlbumController = UIImagePickerController()
            pickerAlbumController.delegate = self
            pickerAlbumController.sourceType = .camera
            pickerAlbumController.cameraCaptureMode = .photo
            pickerAlbumController.modalPresentationStyle = .fullScreen
            self.present(pickerAlbumController, animated: true, completion: nil)
        } else {
            print("camere not avaliable")
            //self.alertError(title: "Ошибка", message: "Камера не доступна")
        }
    }
    
    func media() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            DispatchQueue.main.async {
                let pickerAlbumController = UIImagePickerController()
                pickerAlbumController.delegate = self
                pickerAlbumController.sourceType = .photoLibrary
                pickerAlbumController.mediaTypes = ["public.image"]
                self.present(pickerAlbumController, animated: true, completion: nil)
            }
        } else {
            print("media not avaliable")
            //self.alertError(title: "Ошибка", message: "Медиатека не доступна")
        }
    }
}


//MARK: - Gesture funcs

extension ProfileViewController {
    @objc fileprivate func addAvatar(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Установить из галлереи", style: .default, handler: { (action) in
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { (action) in
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

