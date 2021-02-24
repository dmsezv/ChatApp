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
    @IBOutlet weak var imageAvatar: UIImageView!
    
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
        labelInitials?.addCharacterSpacing(kernValue: charSpacing)
        
        btnEdit?.clipsToBounds = true
        btnEdit?.layer.cornerRadius = cornRadBtn
        
        if let viewAvatar = viewAvatar {
            viewAvatar.clipsToBounds = true
            viewAvatar.layer.cornerRadius = viewAvatar.bounds.width / 2
            let tap = UITapGestureRecognizer(target: self, action: #selector(addAvatar(_ : )))
            viewAvatar.addGestureRecognizer(tap)
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
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageAvatar.image = editedImage.withRenderingMode(.alwaysOriginal)
        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            imageAvatar.image = originalImage.withRenderingMode(.alwaysOriginal)
        }
        
        labelInitials?.isHidden = true
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerGetAvatarFrom(_ type: UIImagePickerController.SourceType) {
        if !UIImagePickerController.isSourceTypeAvailable(type) {
            switch type {
            case .camera:
                alertError("Камера недоступна")
            case .photoLibrary:
                alertError("Галерея недоступна")
            default:
                alertError("Источник недоступен")
            }
            
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = type
        
        picker.modalPresentationStyle = .fullScreen
        
        
        switch type {
        case .camera:
            picker.cameraCaptureMode = .photo
        case .photoLibrary:
            picker.mediaTypes = ["public.image"]
        default:
            return
        }
        
        
        DispatchQueue.main.async {
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func alertError(_ message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}


//MARK: - Gesture funcs

extension ProfileViewController {
    @objc fileprivate func addAvatar(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Установить из галлереи", style: .default, handler: { (action) in
            self.imagePickerGetAvatarFrom(.photoLibrary)
        }))
        
        alertController.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { (action) in
            self.imagePickerGetAvatarFrom(.camera)
        }))
        
        alertController.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

