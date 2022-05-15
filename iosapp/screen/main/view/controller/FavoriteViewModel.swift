//
//  FavoriteViewModel.swift
//  iosapp
//
//  Created by alexander on 09.05.2022.
//

import Foundation
import RxSwift
import UIKit
import RxRelay
import RemoteDataService
import DeveloperToolsSupport

class FavoriteViewModel: ViewModel {
    let disposeBag: DisposeBag = DisposeBag()

    let notAuthorizated = PublishRelay<Void?>()
    let pressSettingButton = PublishRelay<Void?>()




    let currentDataSource = BehaviorRelay<[MiniLot]>(value: [])
    var dataSources: [[MiniLot]] = []



    let currentDataSoruceType = PublishRelay<CategoryType>()
    let dataSourceTypes: [CategoryType] = []



    private let favoriteRepository: FavoriteRepository
    init(_ favoriteRepository: FavoriteRepository){
        self.favoriteRepository = favoriteRepository
        // при выборе плашки загружаем соответтсвующий дата сурс
//        selectedDataSoruceType.bind {
//            self.loadFavoritesByCategory(category: $0)
//        }.disposed(by: disposeBag)
    }

    // вычищение всех данных на
    func resetDataSources() {
        dataSources.removeAll()
    }

    func getCurrentLot(index: Int) {
        let lotId = currentDataSource.value[index].id

    }

//    func deleteAllLots() {
//        let nowData = selectedDataSoruceType.value.name
//        var dataToDelete: [MiniLot] = []
//        switch nowData {
//        case CategoryType.animal.rawValue:
//            dataToDelete = self.animalDataSource!
//        case CategoryType.goods.rawValue:
//            dataToDelete = self.goodsDataSource!
//        default: break
//        }
//
//        dataToDelete.forEach { deleteLot(lotId: $0.id, isAccept: false) }
//
//        switch nowData {
//        case CategoryType.animal.rawValue:
//            currentDataSource.accept(self.animalDataSource!)
//        case CategoryType.goods.rawValue:
//            currentDataSource.accept(self.goodsDataSource!)
//        default: break
//        }
//    }

//    func deleteNotActiveLots() {
//        let nowData =  selectedDataSoruceType.value.name
//        var dataToDelete: [MiniLot] = []
//        switch nowData {
//        case CategoryType.animal.rawValue:
//            dataToDelete = self.animalDataSource!.filter { $0.status != "ACTIVE" }
//        case CategoryType.goods.rawValue:
//            dataToDelete = self.goodsDataSource!.filter { $0.status != "ACTIVE" }
//        default: break
//        }
//        dataToDelete.forEach { deleteLot(lotId: $0.id, isAccept: false) }
//
//        switch nowData {
//        case CategoryType.animal.rawValue:
//            currentDataSource.accept(self.animalDataSource!)
//        case CategoryType.goods.rawValue:
//            currentDataSource.accept(self.goodsDataSource!)
//        default: break
//        }
//    }

//    func deleteLot(lotId: Int, isAccept: Bool) {
//        favoriteRepository.updateLotFavoriteStatus(lotId: lotId, newValue: false) { res in
//            guard res is SuccessResponse<Nothing> else { return }
//
//            //success delete (remove real)
//            let nowData = self.selectedDataSoruceType.value.name
//
//            switch nowData {
//            case CategoryType.animal.rawValue:
//                self.animalDataSource!.removeAll(where: { $0.id == lotId })
//                if isAccept { self.currentDataSource.accept(self.animalDataSource!) }
//            case CategoryType.goods.rawValue:
//                self.goodsDataSource!.removeAll(where: { $0.id == lotId })
//                if isAccept { self.currentDataSource.accept(self.goodsDataSource!) }
//            default: break
//            }
//        }
//    }

//    func loadFavoritesByCategory(category: Category){
//        // загружаем дата сурсы только если они пустые
//        switch category.name {
//        case CategoryType.animal.rawValue:
//            guard animalDataSource == nil else {
//                currentDataSource.accept(animalDataSource!)
//                return
//            }
//        case CategoryType.goods.rawValue:
//            guard goodsDataSource == nil else {
//                currentDataSource.accept(goodsDataSource!)
//                return
//            }
//        default: break
//        }
//
//        favoriteRepository.getFavoriteLots(category: category) { res in
//            guard let response = res as? SuccessResponse<FailableCodableArray<KostulyMiniLot>> else {
//                guard let errorResponse = res as? ErrorResponse else { return }
//                switch errorResponse.status {
//                case 403: self.notAuthorizated.accept(nil)
//                default: fatalError("not handle for \(errorResponse.status)")
//                }
//                return
//            }
//
//            let lots = response.data.elements
//            let updatedLots = lots.map { oldLot in
//                MiniLot(
//                    id: oldLot.id,
//                    title: oldLot.title,
//                    price: oldLot.price,
//                    dateOfPublication: oldLot.dateOfPublication,
//                    status: oldLot.status,
//                    firstImageId: oldLot.firstImageId,
//                    isFavoriteLot: oldLot.inFavorites
//                )
//            }
//
//
//            switch category.name {
//            case CategoryType.animal.rawValue:
//                self.animalDataSource = updatedLots
//            case CategoryType.goods.rawValue:
//                self.goodsDataSource = updatedLots
//            default: break
//            }
//            self.currentDataSource.accept(updatedLots)
//        }
//    }
}

