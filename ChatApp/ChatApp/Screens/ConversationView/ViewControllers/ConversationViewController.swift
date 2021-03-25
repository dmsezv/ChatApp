//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 03.03.2021.
//

import UIKit

protocol ConversationViewDisplayLogic: class {
    func displayList(_ messages: [MessageModel])
}

final class ConversationViewController: UIViewController {
    
    var interactor: ConversationViewBusinessLogic?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBAction func touchButtonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let interactor = ConversationViewInteractor()
        viewController.interactor = interactor
        interactor.viewController = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
        
    // MARK: - Life Cycle
    
    private let cellOutgoingIdentifier = String(describing: ConversationMessageOutgoingViewCell.self)
    private let cellIncomingIdentifier = String(describing: ConversationMessageIncomingViewCell.self)
    private var messages: [MessageModel]?
    var identifierChannel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.getMessagesFrom(identifierChannel)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        interactor?.unsubscribeChannel()
    }
    
    private func setupView() {
        sendMessageButton.isEnabled = false
        sendMessageButton.addTarget(self, action: #selector(touchSendMessageButton(_ :)), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellOutgoingIdentifier, bundle: nil), forCellReuseIdentifier: cellOutgoingIdentifier)
        tableView.register(UINib(nibName: cellIncomingIdentifier, bundle: nil), forCellReuseIdentifier: cellIncomingIdentifier)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.backgroundColor = ThemePicker.shared.currentTheme.backgroundColor
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_ :)))
        tableView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        messageTextField.addTarget(self, action: #selector(messageTextFieldEditing(_ :)), for: .editingChanged)
    }
    
    private func setSendMessageButton(enabled: Bool) {
        sendMessageButton.isEnabled = enabled
        if enabled {
            sendMessageButton.alpha = 0.7
        } else {
            sendMessageButton.alpha = 1.0
        }
    }
}

// MARK: - Display Logic

extension ConversationViewController: ConversationViewDisplayLogic {
    func displayList(_ messages: [MessageModel]) {
        self.messages = messages
        self.messages?.reverse()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let messages = messages else {
            return 0
        }
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let messages = messages else {
            return UITableViewCell()
        }
        
        let model = messages[indexPath.row]
        if model.isIncoming {
            return setupIncomingCell(with: model, tableView, indexPath)
        } else {
            return setupOutgoingCell(with: model, tableView, indexPath)
        }
    }
}

// MARK: - Setup Cells

extension ConversationViewController {
    private func setupIncomingCell(with model: MessageModel, _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIncomingIdentifier, for: indexPath) as? ConversationMessageIncomingViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: model)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
    
    private func setupOutgoingCell(with model: MessageModel, _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellOutgoingIdentifier, for: indexPath) as? ConversationMessageOutgoingViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: model)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
}

// MARK: - Touches

extension ConversationViewController {
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
           let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSValue) as? Double {
            
            let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
            let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
            let intersection = safeAreaFrame.intersection(keyboardFrameInView)

            UIView.animate(withDuration: duration) {
                self.additionalSafeAreaInsets.bottom = intersection.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        if let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSValue) as? Double {
            UIView.animate(withDuration: duration) {
                self.additionalSafeAreaInsets.bottom = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func messageTextFieldEditing(_ textField: UITextField) {
        if let text = textField.text {
            sendMessageButton.isEnabled = !text.isEmpty
        }
    }
    
    @objc private func touchSendMessageButton(_ sender: UIButton) {
        if let message = messageTextField.text {
            messageTextField.text = ""
            sendMessageButton.isEnabled = false
            interactor?.send(message, to: identifierChannel)
        }
    }
}
