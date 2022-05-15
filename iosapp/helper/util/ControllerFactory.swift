//
//  ControllerFactory.swift
//  iosapp
//
//  Created by alexander on 24.04.2022.
//

import Foundation
import UIKit

struct ControllerFactory {
    private static let authRepository = AuthRepository()
    
    public static func get<T: UIViewController>(_ controllerType: T.Type) -> T {
        let storyboard = UIStoryboard(name: String(describing: T.self), bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T
        else { fatalError("") }
        return vc
    }
}
