//
//  CoordinatorProtocol.swift
//  MVVMrxSwift
//
//  Created by Vladislav Miroshnichenko on 24.07.2022.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: class {
    var navigationController: UINavigationController? { get }
    var child : [CoordinatorProtocol] { get }
    
    func start()
    func removeChild(coordinator: CoordinatorProtocol)
}
