//
//  AvatarNetworkInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 19.04.2021.
//

import Foundation
import UIKit

protocol AvatarNetworkBusinessLogic {
    func getUrlsImages()
    func getImage(by url: URL, complete: @escaping((UIImage) -> Void))
}

class AvatarNetworkInteractor: AvatarNetworkBusinessLogic {
    weak var viewController: AvatarNetworkViewControllerDisplayLogic?
    
    private let pixabayService: PixabayServiceProtocol
    
    init(pixabayService: PixabayServiceProtocol) {
        self.pixabayService = pixabayService
    }
    
    func getUrlsImages() {
        pixabayService.getImagesUrls { [weak self] model in
            if let model = model {
                DispatchQueue.main.async {
                    self?.viewController?.displayImages(model.hits!.compactMap { URL(string: $0.previewURL)! })
                }
            } else {
                DispatchQueue.main.async {
                    self?.viewController?.displayError("Can't load data")
                }
            }
        }
    }
    
    func getImage(by url: URL, complete: @escaping((UIImage) -> Void)) {
        pixabayService.getImageData(by: url) { [weak self] data in
            if let data = data, let image = UIImage(data: data) {
                complete(image)
            } else {
                DispatchQueue.main.async {
                    self?.viewController?.displayError("Can't load images")
                }
            }
        }
    }
}
