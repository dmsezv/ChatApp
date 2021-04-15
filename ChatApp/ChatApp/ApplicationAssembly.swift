//
//  ApplicationAssembly.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 15.04.2021.
//

import Foundation

class ApplicationAssembly {
    lazy var coreAssembly: CoreAssemblyProtocol = CoreAssembly()
    lazy var serviceAssembly: ServiceAssemblyProtocol = ServiceAssembly(coreAssembly: coreAssembly)
    lazy var repositoriesAssembly: RepositoriesAssemblyProtocol = RepositoriesAssembly(coreAssembly: coreAssembly)
    lazy var presentationAssembly: PresentationAssemblyProtocol = PresentationAssembly(serviceAssembly: serviceAssembly, repositoriesAssembly: repositoriesAssembly)
}
