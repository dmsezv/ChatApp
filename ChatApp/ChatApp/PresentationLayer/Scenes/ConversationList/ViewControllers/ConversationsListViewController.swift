//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 01.03.2021.
//

import UIKit
import CoreData

protocol ConversationListDisplayLogic: class {
    func channelsLoaded()
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
//    private let animationDelay: TimeInterval = 0.0
//    private let animationDuration: TimeInterval = 1.0
//    private let usingSpringWithDamping: CGFloat = 0.49
//    private let initialSpringVelocity: CGFloat = 0.81
//    private let initialPosition = CGPoint(x: 0, y: 0)
    
    // MARK: - Views
    
    private lazy var profileView: ProfileIconView? = {
        guard  let view = ProfileIconView.instanceFromNib() else {
            return nil
        }
        
        let name = interactor?.fetchSenderName()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchRightBarButton(_:))))
        
        let rightBarButton = UIBarButtonItem(customView: view)
        navigationItem.rightBarButtonItem = rightBarButton
        
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    // MARK: - View life cycle
    
    lazy var managerTransition: UIViewControllerTransitioningDelegate = {
        ManagerViewControllerTransition()
    }()
    
    private let cellIdentifier = String(describing: ConversationListCell.self)
    private var isPresenting = true
    
    private var channelList: [ChannelModel]? {
        return interactor?.fetchChannels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        interactor?.performFetch(delegate: self)
        interactor?.listenChannelChanges()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateProfileView()
        tableView.reloadData()

    }
    
    private func setupView() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundView = activityIndicator
        tableView.separatorStyle = .none
                
        settingsButton.addTarget(self, action: #selector(touchSettingsButton(_:)), for: .touchUpInside)
    }
    
    func updateProfileView() {
        if let name = interactor?.fetchSenderName() {
            profileView?.lettersNameLabel?.text = String(name.prefix(2)).uppercased()
            profileView?.lettersNameLabel.textColor = .black
            profileView?.lettersNameLabel.addCharacterSpacing(kernValue: kernLetterNameValue)
        }
    }
}

//extension ConversationsListViewController: UIViewControllerAnimatedTransitioning {
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        animationDuration
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let container = transitionContext.containerView
//        guard
//            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
//            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
//        else { return }
//
//        toView.transform = rotatingView()
//
//        toView.layer.anchorPoint = initialPosition
//        fromView.layer.anchorPoint = initialPosition
//
//        toView.layer.position = initialPosition
//        fromView.layer.position = initialPosition
//
//        container.addSubview(toView)
//        container.addSubview(fromView)
//
//        let duration = transitionDuration(using: transitionContext)
//
//        UIView.animate(withDuration: duration,
//                       delay: animationDelay,
//                       usingSpringWithDamping: usingSpringWithDamping,
//                       initialSpringVelocity: initialSpringVelocity,
//                       options: []) {
//            fromView.transform = self.rotatingView()
//            toView.transform = .identity
//        } completion: { _ in
//            transitionContext.completeTransition(true)
//        }
//    }
//
//    private func rotatingView() -> CGAffineTransform {
//
//        let offScreenRotateIn = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
//        let offScreenRotateOut = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//
//        return isPresenting ? offScreenRotateIn : offScreenRotateOut
//    }
//}

//extension ConversationsListViewController: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        isPresenting = true
//        return self
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        isPresenting = false
//        return self
//    }
//}


// MARK: - Display Logic

extension ConversationsListViewController: ConversationListDisplayLogic {
    func channelsLoaded() {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            tableView.separatorStyle = .singleLine
        }
    }
    
    func displayError(_ message: String) {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            tableView.separatorStyle = .singleLine
        }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let channel = interactor?.fetchChannel(at: indexPath) else {
            return
        }
                
        router?.routeToMessagesIn(channel)
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
        return channelList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationListCell,
              let channel = interactor?.fetchChannel(at: indexPath) else {
            return UITableViewCell()
        }
        
        cell.configure(with: channel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let id = interactor?.fetchChannel(at: indexPath)?.identifier {
                interactor?.deleteChannel(id)
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
