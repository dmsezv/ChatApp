//
//  AvatarNetwork.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 19.04.2021.
//

import UIKit

protocol AvatarNetworkViewControllerDisplayLogic: class {
    func displayImages(_ urls: [URL])
    func displayError(_ message: String)
    func setAvatar(_ image: UIImage)
}

class AvatarNetworkViewController: UIViewController {
    
    var interactor: AvatarNetworkInteractor?
    var delegate: ProfileViewControllerDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func touchButtonClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Drawing Constraints
    
    let spacing: CGFloat = 8
        
    // MARK: - Life Cycle
    
    let avatarCellId = String(describing: AvatarCollectionViewCell.self)
    var urls: [URL]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        interactor?.getUrlsImages()
    }
    
    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layout
    }
}

// MARK: - Display Logic

extension AvatarNetworkViewController: AvatarNetworkViewControllerDisplayLogic {
    func displayImages(_ urls: [URL]) {
        self.urls = urls
        collectionView.reloadData()
    }
    
    func displayError(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setAvatar(_ image: UIImage) {
        delegate?.setAvatar(image)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension AvatarNetworkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        urls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let urls = urls,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: avatarCellId, for: indexPath) as? AvatarCollectionViewCell else {
            return UICollectionViewCell()
        }
                
        cell.configure()
        interactor?.getImage(by: urls[indexPath.row], complete: { image in
            cell.set(image)
        })
        
        return cell
    }
}

extension AvatarNetworkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 4 * spacing) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}
