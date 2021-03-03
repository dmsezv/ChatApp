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
    private let model = MessageModel.mockMessages()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupView()
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellOutgoingIdentifier, bundle: nil), forCellReuseIdentifier: cellOutgoingIdentifier)
        tableView.register(UINib(nibName: cellIncomingIdentifier, bundle: nil), forCellReuseIdentifier: cellIncomingIdentifier)
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if model[indexPath.row].isIncoming {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIncomingIdentifier, for: indexPath) as? ConversationMessageIncomingViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model[indexPath.row])
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellOutgoingIdentifier, for: indexPath) as? ConversationMessageOutgoingViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model[indexPath.row])
            
            return cell
        }
    }
}
