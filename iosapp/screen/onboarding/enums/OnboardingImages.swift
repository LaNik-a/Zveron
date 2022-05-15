//
//  OnboardingImages.swift
//  iosapp
//
//  Created by Никита Ткаченко on 18.04.2022.
//

import Foundation
import UIKit
enum OnboardingImages: String {
    case onboarding1
    case onboarding2
    case onboarding3
    case onboarding4
    case onboarding5
    
    static func getImage(_ idx: Int) -> UIImage {
        switch idx {
        case 0: return UIImage(named: self.onboarding1.rawValue)!
        case 1: return UIImage(named: self.onboarding2.rawValue)!
        case 2: return UIImage(named: self.onboarding3.rawValue)!
        case 3: return UIImage(named: self.onboarding4.rawValue)!
        case 4: return UIImage(named: self.onboarding5.rawValue)!
        default: return UIImage()
        }
    }
    
}
