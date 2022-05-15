//
//  ModelViewFactory.swift
//  iosapp
//
//  Created by alexander on 17.04.2022.
//

import Foundation
import RxSwift

struct ViewModelFactory {
    private static let authRepository = AuthRepository()
    private static let lotRepository = LotRepository()
    private static let favoriteRepository = FavoriteRepository()
    private static let categoryRepository = CategoryRepository()

    public static func get<T: ViewModel>(_ viewModelType: T.Type) -> T {
        switch viewModelType {
        case is MainAuthViewModel.Type:return( MainAuthViewModel(authRepository) as? T)!
        case is PhonePickerViewModel.Type: return (PhonePickerViewModel(authRepository) as? T)!
        case is CodePickerViewModel.Type: return (CodePickerViewModel(authRepository) as? T)!
        case is NamePasswordPickerViewModel.Type: return (NamePasswordPickerViewModel(authRepository) as? T)!
        case is PhonePasswordPickerViewModel.Type: return (PhonePasswordPickerViewModel(authRepository) as? T)!

        case is LotCellViewModel.Type: return (LotCellViewModel(favoriteRepository) as? T)!
        case is FilterViewModel.Type: return (FilterViewModel(lotRepository, categoryRepository) as? T)!
        case is FirstNestingViewModel.Type: return (FirstNestingViewModel(lotRepository) as? T)!
        case is SecondNestingViewModel.Type: return (SecondNestingViewModel(lotRepository, categoryRepository) as? T)!
        case is ThirdNestingViewModel.Type: return (ThirdNestingViewModel(lotRepository) as? T)!

        case is FavoriteViewModel.Type: return (FavoriteViewModel(favoriteRepository) as? T)!


        case is AddingLotViewModel.Type: return (AddingLotViewModel(lotRepository) as? T)!
        case is AdsViewModel.Type: return (AdsViewModel() as? T)!
        case is CategoryTypeNestedViewModel.Type: return (CategoryTypeNestedViewModel(lotRepository) as? T)!
        case is AddingLotTypeViewModel.Type: return (AddingLotTypeViewModel(categoryRepository) as? T)!
        case is AddingLotDescriptionViewModel.Type: return (AddingLotDescriptionViewModel() as? T)!
        case is AddingLotPriceViewModel.Type: return (AddingLotPriceViewModel() as? T)!
        case is AddingLotAddressViewModel.Type: return (AddingLotAddressViewModel(lotRepository) as? T)!
        default:
            fatalError("Not implemented")
        }
    }
}

protocol ViewModel: AnyObject {
    var disposeBag: DisposeBag { get }
}
