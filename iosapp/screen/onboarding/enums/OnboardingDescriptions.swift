//
//  OnboardingDescriptions.swift
//  iosapp
//
//  Created by Никита Ткаченко on 18.04.2022.
//

import Foundation
import UIKit
enum OnboardingDescriptions: String {
    case onboarding1 = "Используя наше приложение вы сможете находить то, что вам нужно, используя расширенные фильтры для разных категорий животных1"
    case onboarding2 = "Используя наше приложение вы сможете находить то, что вам нужно, используя расширенные фильтры для разных категорий животных2"
    case onboarding3 = "Используя наше приложение вы сможете находить то, что вам нужно, используя расширенные фильтры для разных категорий животных3"
    case onboarding4 = "Используя наше приложение вы сможете находить то, что вам нужно, используя расширенные фильтры для разных категорий животных4"
    case onboarding5 = "Используя наше приложение вы сможете находить то, что вам нужно, используя расширенные фильтры для разных категорий животных5"
    
    
    static func getDescription(_ idx: Int) -> String {
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
