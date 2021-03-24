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
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func touchButtonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Setup
    
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
    
    
    //MARK: - Life Cycle
    
    private let cellOutgoingIdentifier = String(describing: ConversationMessageOutgoingViewCell.self)
    private let cellIncomingIdentifier = String(describing: ConversationMessageIncomingViewCell.self)
    private var messages: [MessageModel]?
    var identifierChannel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        interactor?.getMessagesBy(identifierChannel)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        interactor?.unsubscribeChannel()
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellOutgoingIdentifier, bundle: nil), forCellReuseIdentifier: cellOutgoingIdentifier)
        tableView.register(UINib(nibName: cellIncomingIdentifier, bundle: nil), forCellReuseIdentifier: cellIncomingIdentifier)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.backgroundColor = ThemePicker.shared.currentTheme.backgroundColor
    }
}


//MARK: - Display Logic

extension ConversationViewController: ConversationViewDisplayLogic {
    func displayList(_ messages: [MessageModel]) {
        self.messages = messages.sorted(by: { (prev, next) -> Bool in
            prev.created < next.created
        })
        self.messages?.reverse()
        tableView.reloadData()
    }
}


//MARK: - UITableViewDataSource

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
        return setupIncomingCell(with: model, tableView, indexPath)
//        if model.isIncoming {
//            return setupIncomingCell(with: model, tableView, indexPath)
//        } else {
//            return setupOutgoingCell(with: model, tableView, indexPath)
//        }
    }
}


//MARK: - Setup Cells

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
