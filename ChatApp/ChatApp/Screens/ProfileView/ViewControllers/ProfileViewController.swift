//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.02.2021.
//

import UIKit

protocol ProfileDisplayLogic: class {
    //TODO: нужно завести норм можель и viewModel
    func successFetch(_ userInfo: UserInfoModel)
    func successSavedUserInfo()
    func errorDisplay(_ message: String)
}

class ProfileViewController: UIViewController {
    var interactor: ProfileBusinessLogic?
    
    
    //MARK: - IBOutlets and Views
    
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPositionTextField: UITextField!
    @IBOutlet weak var userCityTextField: UITextField!
    
    @IBOutlet weak var activityIndicatorView: UIView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveGCDButton: UIButton!
    @IBOutlet weak var saveOperationsButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func touchButtonClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 20),
            activityIndicator.heightAnchor.constraint(equalToConstant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor)
        ])
        
        return activityIndicator
    }()
    
    
    // MARK: - Drawing Constants
    
    private let cornRadBtn: CGFloat = 14.0
    private let charSpacing: Double = -22.0
    
    
    //MARK: - Setup
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = ProfileInteractor()
        viewController.interactor = interactor
        interactor.viewController = viewController
    }

    
    //MARK: - Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchUserInfoBy(.gcd)
    }
    
    private func setupView() {
        hideKeyboardWhenTapAround()
        
        initialsLabel.addCharacterSpacing(kernValue: charSpacing)
        initialsLabel.textColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addAvatar(_ : )))
        avatarView.addGestureRecognizer(tap)
        avatarView.clipsToBounds = true
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func fetchDataMode(_ enabled: Bool) {
        if enabled {
            editButton.alpha = 0.5
            editButton.isEnabled = !enabled
            activityIndicator.startAnimating()
        } else {
            editButton.alpha = 1
            editButton.isEnabled = !enabled
            activityIndicator.stopAnimating()
        }
    }
    
    private func editingMode(_ enabled: Bool) {
        let isHidden = enabled
        let isEnabled = !enabled
        
        editButton.isHidden = isHidden
        editButton.isEnabled = isEnabled
        
        userNameTextField.isEnabled = !isEnabled
        userCityTextField.isEnabled = !isEnabled
        userPositionTextField.isEnabled = !isEnabled
        
        if enabled {
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
    
    private func savingMode(_ enable: Bool) {
        saveGCDButton.isEnabled = !enable
        saveOperationsButton.isEnabled = !enable
        
        if enable {
            saveGCDButton.alpha = 0.5
            saveOperationsButton.alpha = 0.5
            
            activityIndicator.startAnimating()
        } else {
            saveGCDButton.alpha = 1
            saveOperationsButton.alpha = 1
            
            activityIndicator.stopAnimating()
        }
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


//MARK: - Business Logic

extension ProfileViewController {
    func fetchUserInfoBy(_ type: UserInfoSaverType) {
        //TODO: нужно придумать машину состояний VC
        editingMode(false)
        savingMode(false)
        fetchDataMode(true)
                
        interactor?.fetchUserInfoBy(type)
    }
    
    func saveUserInfo(_ model: UserInfoModel, _ saverType: UserInfoSaverType) {
        savingMode(true)
        
        activityIndicator.startAnimating()
        
        let userInfo = UserInfoModel(
            name: userNameTextField.text,
            position: userPositionTextField.text,
            city: userCityTextField.text)
        
        interactor?.save(userInfo: userInfo, by: saverType)
    }
}


//MARK: - Display Logic

extension ProfileViewController: ProfileDisplayLogic {
    func successSavedUserInfo() {
        editingMode(false)
        savingMode(false)
    }
    
    func successFetch(_ userInfo: UserInfoModel) {
        editingMode(false)
        savingMode(false)
        fetchDataMode(false)
        
        userNameTextField.text = userInfo.name
        userCityTextField.text = userInfo.city
        userPositionTextField.text = userInfo.position
    }
    
    func errorDisplay(_ message: String) {
        fetchDataMode(false)
        editingMode(false)
        savingMode(false)
        
        alertError(message)
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
        savingMode(false)
    }
    
    @objc func touchSaveGCDButton(_ sender: UIButton) {
        saveUserInfoBy(.gcd)
    }
    
    @objc func touchSaveOperationsButton(_ sender: UIButton) {
        saveUserInfoBy(.operation)
    }
    
    private func saveUserInfoBy(_ saverType: UserInfoSaverType) {
        savingMode(true)
        activityIndicator.startAnimating()
        
        let userInfo = UserInfoModel(
            name: userNameTextField.text,
            position: userPositionTextField.text,
            city: userCityTextField.text)
        
        interactor?.save(userInfo: userInfo, by: saverType)
    }
}


//MARK: - Events

extension ProfileViewController {
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if view.frame.origin.y == 0 {
//                view.frame.origin.y -= keyboardSize.height
//            }
            
            var rectSize: CGRect = view.frame
            rectSize.size.height -= keyboardSize.height
            
            if userNameTextField.isFirstResponder, !rectSize.contains(userNameTextField.frame.origin) {
                view.frame.origin.y = userNameTextField.frame.origin.y
                
            } else if userPositionTextField.isFirstResponder, !rectSize.contains(userPositionTextField.frame.origin) {
                view.frame.origin.y = userPositionTextField.frame.origin.y
                
            } else if userCityTextField.isFirstResponder {
                view.frame.origin.y = -userCityTextField.frame.origin.y + keyboardSize.height
                
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}

