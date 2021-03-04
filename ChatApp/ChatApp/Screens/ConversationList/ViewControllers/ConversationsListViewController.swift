//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 01.03.2021.
//

import Foundation
import UIKit

final class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    private let cellIdentifier = String(describing: ConversationListCell.self)
    
    //знаю, что это все плохо и некрасиво, обязательно поправлю в сл домашке.
    private enum TableSection: String, CaseIterable {
        case online = "Online"
        case history = "History"
        
        func getSectionIndex() -> Int {
            switch self {
            case .online: return 0
            case .history: return 1
            }
        }
        
        static func getSectionTitleBy(index: Int) -> String? {
            switch index {
            case 0: return TableSection.online.rawValue
            case 1: return TableSection.history.rawValue
            default: return nil
            }
        }
    }
    
    //знаю, что это все плохо и некрасиво, обязательно поправлю в сл домашке.
    //нужен какойнить interactor, чтоб за датой ходить в репы, например
    private lazy var modelOnline = ConversationModel.mockConversationsOnline()
    private lazy var modelHistory = ConversationModel.mockConversationsHistory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupView() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChatSegue" {
            if let destinationVC = segue.destination as? ConversationViewController,
               let nameTitle = sender as? String? {
                destinationVC.title = nameTitle
            }
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //здесь, конечно, нужен router
        switch indexPath.section {
        case TableSection.history.getSectionIndex():
            performSegue(withIdentifier: "showChatSegue", sender: modelHistory[indexPath.row].name)
        case TableSection.online.getSectionIndex():
            performSegue(withIdentifier: "showChatSegue", sender: modelOnline[indexPath.row].name)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        TableSection.getSectionTitleBy(index: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection.allCases[section] {
        case .history:  return modelOnline.count
        case .online:   return modelHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationListCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case TableSection.history.getSectionIndex():
            cell.configure(with: modelHistory[indexPath.row])
        case TableSection.online.getSectionIndex():
            cell.configure(with: modelOnline[indexPath.row])
        default:
            return UITableViewCell()
        }
        
        return cell
    }
}
