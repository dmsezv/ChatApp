//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 03.03.2021.
//

import UIKit
import CoreData

protocol ConversationViewDisplayLogic: class {
    func messagesLoaded()
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
    
    // MARK: - Views
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
        
    // MARK: - Life Cycle
    
    private let cellOutgoingIdentifier = String(describing: ConversationMessageOutgoingViewCell.self)
    private let cellIncomingIdentifier = String(describing: ConversationMessageIncomingViewCell.self)
    // TODO: по хорошему его нужно перебросить в интерактор, тк он не является view
    // и оттуда дергать что нужно. Но я не успеваю
    private lazy var fetchedResultController: NSFetchedResultsController<MessageDB> = {
        let request: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        request.predicate = NSPredicate(format: "channel.identifier == %@", interactor?.channel?.identifier ?? "")
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        request.resultType = .managedObjectResultType

        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataStack.shared.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        controller.delegate = self
        return controller
    }()
    private var messageList: [MessageDB]? {
        fetchedResultController.fetchedObjects
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        do {
            try fetchedResultController.performFetch()
            interactor?.listenMessagesChanges()
        } catch {
            printOutput(error.localizedDescription)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        interactor?.unsubscribeChannel()
    }
    
    private func setupView() {
        sendMessageButton.isEnabled = false
        sendMessageButton.addTarget(self, action: #selector(touchSendMessageButton(_ :)), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: cellOutgoingIdentifier, bundle: nil), forCellReuseIdentifier: cellOutgoingIdentifier)
        tableView.register(UINib(nibName: cellIncomingIdentifier, bundle: nil), forCellReuseIdentifier: cellIncomingIdentifier)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.backgroundColor = ThemePicker.shared.currentTheme.backgroundColor
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_ :)))
        tableView.addGestureRecognizer(tap)
        tableView.backgroundView = activityIndicator
        
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
    func messagesLoaded() {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = MessageModel.createFrom(fetchedResultController.object(at: indexPath)) else {
            return UITableViewCell()
        }
        
        if message.isIncoming {
            return setupIncomingCell(with: message, tableView, indexPath)
        } else {
            return setupOutgoingCell(with: message, tableView, indexPath)
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

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath,
               let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            break
        }
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
            
            interactor?.send(message)
        }
    }
}
