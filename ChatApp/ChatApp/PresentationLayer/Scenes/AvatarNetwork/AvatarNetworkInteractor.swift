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
        pixabayService.getImagesUrls { [weak self] urls in
            DispatchQueue.main.async {
                self?.viewController?.displayImages(urls)
            }
        }
    }
    
    func getImage(by url: URL, complete: @escaping((UIImage) -> Void)) {
        pixabayService.getImageData(by: url) { data in
            complete(UIImage(data: data)!)
        }
    }
}
