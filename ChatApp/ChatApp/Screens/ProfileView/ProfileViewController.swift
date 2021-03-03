//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var labelInitials: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var viewAvatar: UIView!
    @IBOutlet weak var imageAvatar: UIImageView!
    
    @IBAction func touchButtonClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Drawing Constants
    
    private let cornRadBtn: CGFloat = 14.0
    private let charSpacing: Double = -22.0
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //на данном этапе вьюхи еще не инициализированны
        if let btnEdit = btnEdit {
            log("\(btnEdit.frame)")
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //на данном этапе вьюхи еще не инициализированны
        if let btnEdit = btnEdit {
            log("\(btnEdit.frame)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        //здесь вьюхи проинициализированны, но их значения взяты из IB.
        //по заданию устройство в IB и в симуляторе разных размеров отсюда и разные фреймы
        //окончательно все размеры посчитаются во viewDidLayoutSubviews
        if let btnEdit = btnEdit {
            log("\(#function) btnEdit.frame = \(btnEdit.frame)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //на данном этапе frame корректный, уже все размеры посчитаны и вьюхи стоят правильно
        //тк до этого метода уже вызвался viewDidLayoutSubviews
        if let btnEdit = btnEdit {
            log("\(#function) btnEdit.frame = \(btnEdit.frame)")
        }
    }
    
    private func setupView() {
        labelInitials?.addCharacterSpacing(kernValue: charSpacing)
        
        btnEdit?.clipsToBounds = true
        btnEdit?.layer.cornerRadius = cornRadBtn
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addAvatar(_ : )))
        viewAvatar?.addGestureRecognizer(tap)
        viewAvatar?.clipsToBounds = true
    }
    
    private func setupLayout() {
        if let viewAvatar = viewAvatar {
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


//MARK: - Gesture funcs

extension ProfileViewController {
    @objc fileprivate func addAvatar(_ sender: UITapGestureRecognizer) {
        guard let viewAvatar = viewAvatar else {
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
}

