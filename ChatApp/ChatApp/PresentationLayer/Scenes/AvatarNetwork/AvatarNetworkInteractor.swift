//
//  AvatarNetworkInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 19.04.2021.
//

import Foundation
import UIKit

class Avatar {
    var id: Int
    var previewImageUrl: URL
    var fullImageUrl: URL
    var image: UIImage?

    init(id: Int, previewImageUrl: URL, fullImageUrl: URL) {
        self.id = id
        self.fullImageUrl = fullImageUrl
        self.previewImageUrl = previewImageUrl
    }
}

protocol AvatarNetworkBusinessLogic {
    func getImagesIds()
    func getImage(by id: Int, complete: @escaping((UIImage) -> Void))
    func getBigImage(by id: Int, complete: @escaping((UIImage) -> Void))
}

class AvatarNetworkInteractor: AvatarNetworkBusinessLogic {
    weak var viewController: AvatarNetworkViewControllerDisplayLogic?
    private var avatarNetworkDataSource: [Avatar] = []
    
    private let pixabayService: PixabayServiceProtocol
    
    init(pixabayService: PixabayServiceProtocol) {
        self.pixabayService = pixabayService
    }
    
    func getImagesIds() {
        pixabayService.getImagesUrls { [weak self] model in
            if let hits = model?.hits {
                for hit in hits {
                    if let previewImageUrl = URL(string: hit.previewURL),
                       let fullImageUrl = URL(string: hit.largeImageURL) {
                        self?.avatarNetworkDataSource.append(
                            Avatar(id: hit.id,
                                previewImageUrl: previewImageUrl,
                                fullImageUrl: fullImageUrl))
                    }
                }
                
                DispatchQueue.main.async {
                    // TODO: завести нормальную viewModel и слой с презентером никак не успеваю, пока так
                    self?.viewController?.displayImages(self?.avatarNetworkDataSource.compactMap { $0.id } ?? [])
                }
            } else {
                DispatchQueue.main.async {
                    self?.viewController?.displayError("Can't load data")
                }
            }
        }
    }
    
    func getImage(by id: Int, complete: @escaping((UIImage) -> Void)) {
        guard let avatar = avatarNetworkDataSource.first(where: { $0.id == id }) else {
            DispatchQueue.main.async {
                self.viewController?.displayError("Can't load images")
            }
            
            return
        }
        
        if let image = avatar.image {
            complete(image)
        } else {
            self.pixabayService.getImageData(by: avatar.previewImageUrl) { [weak self] data in
                
                if let data = data, let image = UIImage(data: data) {
                    self?.avatarNetworkDataSource.first(where: { $0.id == id })?.image = image
                    
                    DispatchQueue.main.async {
                        complete(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.viewController?.displayError("Can't load images")
                    }
                }
            }
        }
    }
    
    func getBigImage(by id: Int, complete: @escaping((UIImage) -> Void)) {
        guard let avatar = avatarNetworkDataSource.first(where: { $0.id == id }) else {
            DispatchQueue.main.async {
                self.viewController?.displayError("Can't load big image")
            }
            
            return
        }
        
        pixabayService.getImageData(by: avatar.fullImageUrl) { [weak self] data in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self?.avatarNetworkDataSource.first(where: { $0.id == id })?.image = image
                    complete(image)
                } else {
                    
                    self?.viewController?.displayError("Can't load images")
                }
            }
        }
    }

}
