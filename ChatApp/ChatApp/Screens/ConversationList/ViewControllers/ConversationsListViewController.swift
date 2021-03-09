//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 01.03.2021.
//

import Foundation
import UIKit

final class ConversationsListViewController: UIViewController {
    
    var router: ConversationListRoutingLogic?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Drawing Constants
    
    private let profileButtonFrame: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40)
    private let kernLetterNameValue: Double = -4
    
    
    //MARK: - Setup
    
    private func setup() {
        let viewController = self
        let router = ConversationListRouter()
        viewController.router = router
        router.viewController = viewController
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    //MARK: - View life cycle
    
    private let cellIdentifier = String(describing: ConversationListCell.self)
    private var viewModelMessages: ConversationsListViewController.ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupView() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadData() {
        //TODO: поставить потом интерактор, чтоб ходить за данными в репы и в нем их приводить впорядок

        let historyMessages = DataProvider.getMockConversationsHistory()
        let onlineMessages = DataProvider.getMockConversationsOnline()
        
        viewModelMessages = ConversationsListViewController.ViewModel(
            historyMessages: historyMessages,
            onlineMessages: onlineMessages)
        
        if let view = ProfileIconView.instanceFromNib() {
            view.lettersNameLabel.text = "MD"
            view.lettersNameLabel.addCharacterSpacing(kernValue: kernLetterNameValue)
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchRightBarButton(_:))))
            let rightBarButton = UIBarButtonItem(customView: view)
            navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO: нужен router
        if segue.identifier == "showChatSegue" {
            if let destinationVC = segue.destination as? ConversationViewController,
               let nameTitle = sender as? String? {
                destinationVC.title = nameTitle ?? "Unknown User"
            }
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let vm = viewModelMessages else {
            return
        }
        
        //TODO: нужен router
        switch indexPath.section {
        case TableSection.history.getSectionIndex():
            performSegue(withIdentifier: "showChatSegue", sender: vm.historyMessages[indexPath.row].name)
        case TableSection.online.getSectionIndex():
            performSegue(withIdentifier: "showChatSegue", sender: vm.onlineMessages[indexPath.row].name)
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
        guard let vm = viewModelMessages else {
            return 0
        }
        
        switch TableSection.allCases[section] {
        case .history:  return vm.historyMessages.count
        case .online:   return vm.onlineMessages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationListCell,
              let vm = viewModelMessages else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case TableSection.history.getSectionIndex():
            cell.configure(with: vm.historyMessages[indexPath.row])
        case TableSection.online.getSectionIndex():
            cell.configure(with: vm.onlineMessages[indexPath.row])
        default:
            return UITableViewCell()
        }
        
        return cell
    }
}


extension ConversationsListViewController {
    //знаю, что это все плохо и некрасиво, но пока так.
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
    
    //TODO: сделать норм ViewModel
    private struct ViewModel {
        var historyMessages: [ConversationModel]
        var onlineMessages: [ConversationModel]
    }
}


//MARK: - Touches

extension ConversationsListViewController {
    @objc private func touchRightBarButton(_ sender: UITapGestureRecognizer) {
        router?.routeToProfile()
    }
}
