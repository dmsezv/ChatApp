//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 03.03.2021.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellOutgoingIdentifier = String(describing: ConversationMessageOutgoingViewCell.self)
    private let cellIncomingIdentifier = String(describing: ConversationMessageIncomingViewCell.self)
    private var model = MessageModel.mockMessages()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        model.reverse()
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellOutgoingIdentifier, bundle: nil), forCellReuseIdentifier: cellOutgoingIdentifier)
        tableView.register(UINib(nibName: cellIncomingIdentifier, bundle: nil), forCellReuseIdentifier: cellIncomingIdentifier)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if model[indexPath.row].isIncoming {
            return setupIncomingCell(tableView, cellForRowAt: indexPath)
        } else {
            return setupOutgoingCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    private func setupIncomingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIncomingIdentifier, for: indexPath) as? ConversationMessageIncomingViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: model[indexPath.row])
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

        return cell
    }
    
    private func setupOutgoingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellOutgoingIdentifier, for: indexPath) as? ConversationMessageOutgoingViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: model[indexPath.row])
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

        return cell
    }
}
