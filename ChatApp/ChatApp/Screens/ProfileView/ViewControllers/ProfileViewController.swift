//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveGCDButton: UIButton!
    @IBOutlet weak var saveOperationsButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBAction func touchButtonClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Drawing Constants
    
    private let cornRadBtn: CGFloat = 14.0
    private let charSpacing: Double = -22.0
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        hideKeyboardWhenTapAround()
        
        initialsLabel.addCharacterSpacing(kernValue: charSpacing)
        initialsLabel.textColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addAvatar(_ : )))
        avatarView.addGestureRecognizer(tap)
        avatarView.clipsToBounds = true
        
        userNameTextField.isEnabled = false
        
        setupViewButtons()
    }
    
    private func setupViewButtons() {
        editButton.clipsToBounds = true
        editButton.layer.cornerRadius = cornRadBtn
        editButton.addTarget(self, action: #selector(touchEditButton(_:)), for: .touchUpInside)
        
        saveGCDButton.clipsToBounds = true
        saveGCDButton.layer.cornerRadius = cornRadBtn
        saveGCDButton.addTarget(self, action: #selector(touchSaveGCDButton(_:)), for: .touchUpInside)
        
        saveOperationsButton.clipsToBounds = true
        saveOperationsButton.layer.cornerRadius = cornRadBtn
        saveOperationsButton.addTarget(self, action: #selector(touchSaveOperationsButton(_:)), for: .touchUpInside)
        
        cancelButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = cornRadBtn
        cancelButton.addTarget(self, action: #selector(touchCancelButton(_:)), for: .touchUpInside)
        
        editingMode(false)
    }
    
    private func editingMode(_ enabled: Bool) {
        let isHidden = enabled
        let isEnabled = !enabled
        
        editButton.isHidden = isHidden
        editButton.isEnabled = isEnabled
        
        userNameTextField.isEnabled = !isEnabled
        if !isEnabled {
            userNameTextField.becomeFirstResponder()
        } else {
            userNameTextField.resignFirstResponder()
        }
        
        saveGCDButton.isHidden = !isHidden
        saveGCDButton.isEnabled = !isEnabled
        saveOperationsButton.isHidden = !isHidden
        saveOperationsButton.isEnabled = !isEnabled
        cancelButton.isHidden = !isHidden
        cancelButton.isEnabled = !isEnabled
    }
    
    private func setupLayout() {
        if let viewAvatar = avatarView {
            viewAvatar.layer.cornerRadius = viewAvatar.bounds.width / 2
        }
    }
    
    private func alertError(_ message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}


//MARK: - UIImage Picker

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            avatarImageView.image = editedImage.withRenderingMode(.alwaysOriginal)
        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            avatarImageView.image = originalImage.withRenderingMode(.alwaysOriginal)
        }
        
        initialsLabel?.isHidden = true
        
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
        
        let picker = setupCommonProfileVCPicker()
        picker.sourceType = type
        
        switch type {
        case .camera:
            picker.cameraCaptureMode = .photo
        case .photoLibrary:
            picker.mediaTypes = ["public.image"]
        default:
            return
        }
        
        
        self.present(picker, animated: true, completion: nil)
    }
    
    private func setupCommonProfileVCPicker() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        
        return picker
    }
}


//MARK: - Touches

extension ProfileViewController {
    @objc fileprivate func addAvatar(_ sender: UITapGestureRecognizer) {
        guard let viewAvatar = avatarView else {
            return
        }
        
        let locationTap = sender.location(in: viewAvatar)
        let path = UIBezierPath.init(ovalIn: viewAvatar.bounds)
        
        if path.contains(locationTap) {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Установить из галлереи", style: .default, handler: { (action) in
                self.imagePickerGetAvatarFrom(.photoLibrary)
            }))
            
            alertController.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { (action) in
                self.imagePickerGetAvatarFrom(.camera)
            }))
            
            alertController.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func touchEditButton(_ sender: UIButton) {
        editingMode(true)
    }
    
    @objc func touchCancelButton(_ sender: UIButton) {
        editingMode(false)
    }
    
    @objc func touchSaveGCDButton(_ sender: UIButton) {
        
    }
    
    @objc func touchSaveOperationsButton(_ sender: UIButton) {
        
    }
}

