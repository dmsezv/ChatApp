//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 03.03.2021.
//

import UIKit

final class ConversationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellOutgoingIdentifier = String(describing: ConversationMessageOutgoingViewCell.self)
    private let cellIncomingIdentifier = String(describing: ConversationMessageIncomingViewCell.self)
    
    @IBAction func touchButtonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private var viewModelMessages: ConversationViewController.ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellOutgoingIdentifier, bundle: nil), forCellReuseIdentifier: cellOutgoingIdentifier)
        tableView.register(UINib(nibName: cellIncomingIdentifier, bundle: nil), forCellReuseIdentifier: cellIncomingIdentifier)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.backgroundColor = ThemePicker.shared.currentTheme.backgroundColor
    }
    
    private func loadData() {
        //TODO: поставить потом интерактор, чтоб ходить за данными в репы и в нем их приводить впорядок
        var msgs = DataProvider.getMockMessages()
        msgs.reverse()
        
        viewModelMessages = ConversationViewController.ViewModel(messages: msgs)
    }
}


//MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vm = viewModelMessages else {
            return 0
        }
        
        return vm.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let vm = viewModelMessages else {
            return UITableViewCell()
        }
        
        
        let model = vm.messages[indexPath.row]
        if model.isIncoming {
            return setupIncomingCell(with: model, tableView, indexPath)
        } else {
            return setupOutgoingCell(with: model, tableView, indexPath)
        }
    }
}


//MARK: - Setup Cells

extension ConversationViewController {
    private func setupIncomingCell(with model: MessageCellConfiguration, _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIncomingIdentifier, for: indexPath) as? ConversationMessageIncomingViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: model)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
    
    private func setupOutgoingCell(with model: MessageCellConfiguration, _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellOutgoingIdentifier, for: indexPath) as? ConversationMessageOutgoingViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: model)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
}


extension ConversationViewController {
    private struct ViewModel {
        var messages: [MessageModel]
    }
}
