//
//  LotCellViewModel.swift
//  iosapp
//
//  Created by alexander on 03.05.2022.
//

import Foundation
import RxSwift
import RxRelay
import RemoteDataService

class LotCellViewModel: ViewModel {

    let disposeBag: DisposeBag = DisposeBag()

    let needAuth = PublishRelay<Void?>()
    
    let title = PublishRelay<String>()
    let price = PublishRelay<String>()
    let date = PublishRelay<String>()
    let pictureUrl = PublishRelay<URL>()
    let favoriteImage = PublishRelay<UIImage>()
    let status = PublishRelay<String>()

    let data = BehaviorRelay<MiniLot?>(value: nil)

    private let favoriteRepository: FavoriteRepository
    init(_ favoriteRepository: FavoriteRepository) {
        self.favoriteRepository = favoriteRepository
        let unFavoriteImage = #imageLiteral(resourceName: "unfavorite")
        let favoriteImage = #imageLiteral(resourceName: "favorite")
        data.subscribe(onNext: { lot in
            guard let lot = lot else { return }

            self.title.accept(lot.title)
            if lot.price != nil {
                self.price.accept("\(lot.price!.formattedWithSeparator) ₽")
            } else {
                self.price.accept("Не указано")
            }
            self.date.accept(lot.dateOfPublication.parseToNewFormat(format: "d MMMM yyyy"))
            self.favoriteImage.accept(lot.isFavoriteLot ? favoriteImage : unFavoriteImage)
            let url = "\(RemoteDataConstant.BASE_URL)/api/data/photo/\(lot.firstImageId)"
            self.pictureUrl.accept(URL(string: url)!)

            guard let status = lot.status else { return }
            self.status.accept(status)
        }).disposed(by: disposeBag)
    }

    func updateFavoriteState() {
        let oldData = data.value!

        favoriteRepository.updateLotFavoriteStatus(
            lotId: oldData.id,
            newValue: !oldData.isFavoriteLot
        ) { res in
            guard let response = res as? ErrorResponse else {
                let newData = MiniLot(
                    id: oldData.id,
                    title: oldData.title,
                    price: oldData.price,
                    dateOfPublication: oldData.dateOfPublication,
                    status: oldData.status,
                    firstImageId: oldData.firstImageId,
                    isFavoriteLot: !oldData.isFavoriteLot
                )

                self.data.accept(newData)
                return
            }

            if response.status == HTTPStatus.Forbidden.rawValue {
                self.needAuth.accept(nil)
                return
            }

            if response.status == 400 {
                let newData = MiniLot(
                    id: oldData.id,
                    title: oldData.title,
                    price: oldData.price,
                    dateOfPublication: oldData.dateOfPublication,
                    status: oldData.status,
                    firstImageId: oldData.firstImageId,
                    isFavoriteLot: !oldData.isFavoriteLot
                )

                self.data.accept(newData)
                return
            }

            fatalError("Not Implemented error \(response)")
        }
    }
}
