//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 01.03.2021.
//

import Foundation
import UIKit

protocol ConversationListDisplayLogic: class {
    func displayList(_ channels: [ChannelModel])
    func displayError(_ message: String)
}

protocol ConversationsListDelegate {
    func updateProfileView() 
}

final class ConversationsListViewController: UIViewController, ConversationsListDelegate {
    
    var interactor: ConversationListBusinessLogic?
    var router: ConversationListRoutingLogic?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsButton: UIButton!
    
    // MARK: - Drawing Constants
    
    private let profileButtonFrame: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40)
    private let kernLetterNameValue: Double = -4
    private let titleViewHeight: CGFloat = 45
    private let titleLabelPaddingX: CGFloat = 10
    private let titleLabelPaddingY: CGFloat = 0
    private let titleLableFontSize: CGFloat = 15
    
    // MARK: - Views
    
    private lazy var profileView: ProfileIconView? = {
        guard  let view = ProfileIconView.instanceFromNib() else {
            return nil
        }
        
        let name = UserInfoSaverGCD().fetchSenderName()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchRightBarButton(_:))))
        
        let rightBarButton = UIBarButtonItem(customView: view)
        navigationItem.rightBarButtonItem = rightBarButton
        
        return view
    }()
        
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let router = ConversationListRouter()
        let interactor = ConversationListInteractor()
        viewController.router = router
        viewController.interactor = interactor
        router.viewController = viewController
        interactor.viewController = viewController
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - View life cycle
    
    private var channels: [ChannelModel]?
    private let cellIdentifier = String(describing: ConversationListCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateProfileView()
        interactor?.getChannelList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.unsubscribeChannel()
    }
    
    private func setupView() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
                
        settingsButton.addTarget(self, action: #selector(touchSettingsButton(_:)), for: .touchUpInside)
    }
    
    func updateProfileView() {
        let name = UserInfoSaverGCD().fetchSenderName()
        profileView?.lettersNameLabel?.text = String(name.prefix(2)).uppercased()
        profileView?.lettersNameLabel.textColor = .black
        profileView?.lettersNameLabel.addCharacterSpacing(kernValue: kernLetterNameValue)
    }
}

// MARK: - Display Logic

extension ConversationsListViewController: ConversationListDisplayLogic {
    func displayList(_ channels: [ChannelModel]) {
        self.channels = channels
        tableView.reloadData()
    }
    
    func displayError(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let channels = channels else {
            return
        }
        
//        router?.routeToShowChat(title: channels[indexPath.row].name, identifierChannel: channels[indexPath.row].identifier)
        router?.routeToMessagesIn(channels[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: titleViewHeight))
        viewHeader.backgroundColor = ThemePicker.shared.currentTheme.backgroundColor
        
        let label = UILabel(frame: CGRect(x: titleLabelPaddingX, y: titleLabelPaddingY, width: viewHeader.frame.width, height: viewHeader.frame.height))
        label.text = "Channels"
        label.textColor = ThemePicker.shared.currentTheme.textColor
        label.font = .boldSystemFont(ofSize: titleLableFontSize)
        
        let button = UIButton()
        button.setTitle("Add channel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: titleLableFontSize)
        button.frame = CGRect(
            x: viewHeader.frame.width - button.intrinsicContentSize.width - titleLabelPaddingX,
            y: titleLabelPaddingY,
            width: button.intrinsicContentSize.width,
            height: viewHeader.frame.height)
        button.addTarget(self, action: #selector(touchAddChannelButton(_ :)), for: .touchUpInside)
        
        viewHeader.addSubview(button)
        viewHeader.addSubview(label)
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        titleViewHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let channels = channels else {
            return 0
        }
        
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationListCell,
              let channels = channels else {
            return UITableViewCell()
        }
        
        cell.configure(with: channels[indexPath.row])
        
        return cell
    }
}

// MARK: - Touches

extension ConversationsListViewController {
    @objc private func touchRightBarButton(_ sender: UITapGestureRecognizer) {
        router?.routeToProfile()
    }
    
    @objc private func touchSettingsButton(_ sender: UIButton) {
        router?.routeToSettings()
    }
    
    @objc private func touchAddChannelButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add new channel", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter name of channel"
        }
        alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            self.interactor?.createChannel(alertController.textFields?[0].text)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
