//
//  OnboardingTitles.swift
//  iosapp
//
//  Created by Никита Ткаченко on 18.04.2022.
//

import Foundation
import UIKit
enum OnboardingTitles: String {
    case onboarding1 = "Все для животных в одном приложении1"
    case onboarding2 = "Все для животных в одном приложении2"
    case onboarding3 = "Все для животных в одном приложении3"
    case onboarding4 = "Все для животных в одном приложении4"
    case onboarding5 = "Все для животных в одном приложении5"
    
    static func getTitle(_ idx: Int) -> String {
        switch idx {
        case 0: return self.onboarding1.rawValue
        case 1: return self.onboarding2.rawValue
        case 2: return self.onboarding3.rawValue
        case 3: return self.onboarding4.rawValue
        case 4: return self.onboarding5.rawValue
        default: return ""
        }
    }
    
}
