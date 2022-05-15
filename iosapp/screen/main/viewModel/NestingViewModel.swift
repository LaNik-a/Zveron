//
//  SecondNestingViewModel.swift
//  iosapp
//
//  Created by alexander on 07.05.2022.
//

import Foundation
import RxSwift
import RxRelay
import RemoteDataService

protocol NestingViewModelBase: ViewModel {
    var sortingType: BehaviorRelay<SortingType> { get }
    var presentationModeType: BehaviorRelay<PresentModeType> { get }
    var currentOffset: PublishRelay<CGFloat> { get }
    var filter: BehaviorRelay<FilterModel> { get }
}

protocol NestingViewModelCollectionView: NestingViewModelBase {
    var endLoadData: PublishRelay<Void?> { get }
    var selectedLot: PublishRelay<Void?> { get }
    var lots: BehaviorRelay<[MiniLot]> { get }
    var currentLot: PublishRelay<Lot> { get }
    var nonAutharizated: PublishRelay<Void?> { get }
    var fetchAllLots: BehaviorRelay<Bool> { get }
    var needToDisplayTop: PublishRelay<Void?> { get }

    func updateLots()
    func fetchLots()
    func getCurrentLot(index: Int)
}

class NestingViewModel: NestingViewModelCollectionView {
    let endLoadData = PublishRelay<Void?>()
    let fetchAllLots = BehaviorRelay<Bool>(value: false)


    let selectedLot = PublishRelay<Void?>()

    let currentLot = PublishRelay<Lot>()

    let lots = BehaviorRelay<[MiniLot]>(value: [])

    let nonAutharizated = PublishRelay<Void?>()

    let currentOffset = PublishRelay<CGFloat>()

    let sortingType = BehaviorRelay<SortingType>(value: .popularity)

    let presentationModeType = BehaviorRelay<PresentModeType>(value: .grid)

    let disposeBag: DisposeBag = DisposeBag()

    let filter = BehaviorRelay<FilterModel>(value: FilterModel(sortingType: .popularity))

    let lotRepository: LotRepository

    let needToDisplayTop = PublishRelay<Void?>()

    init(_ lotRepository: LotRepository) {
        self.lotRepository = lotRepository

        filter.bind {_ in
            self.needToDisplayTop.accept(nil)
            self.currentOffset.accept(0)
            self.updateLots()
        }.disposed(by: disposeBag)

        sortingType.bind(onNext: { mode in
            let oldFilter = self.filter.value
            self.filter.accept(oldFilter.updateFields(sortingType: mode))
        }).disposed(by: disposeBag)
    }

    func getCurrentLot(index: Int) {
        let id = lots.value[index].id
//        lotRepository.getLot(lotId: lotId) { res in
//            guard let response = res as? SuccessResponse<Lot> else {
//                self.lot.accept(nil)
//                return
//            }
//            self.lot.accept(response.data)
//        }
    }

    func updateLots() {
        let requestLotDto = RequestLotDto(
            pageSize: 20,
            filterModel: filter.value
        )

        lotRepository.getLots(request: requestLotDto) { res in
            guard let response = res as? SuccessResponse<FailableCodableArray<MiniLot>> else {
                return
            }
            self.lots.accept(response.data.elements)
            self.endLoadData.accept(nil)
            self.fetchAllLots.accept(false)
        }
    }

    var fetchLotsInProccess: Bool = false

    func fetchLots() {
        guard fetchLotsInProccess == false else { return }
        fetchLotsInProccess.toggle()

        var requestLotDto = RequestLotDto(
            pageSize: 20,
            filterModel: filter.value
        )

        if let lastLot = lots.value.last {
            requestLotDto.lotId = lastLot.id
            requestLotDto.dateCreationLot = lastLot.dateOfPublication
        }

        lotRepository.getLots(request: requestLotDto) { res in
            guard let response = res as? SuccessResponse<FailableCodableArray<MiniLot>> else {
                return    
            }
            let newLots = response.data.elements
            if newLots.isEmpty { self.fetchAllLots.accept(true) }
            var updatedLots = self.lots.value
            updatedLots.append(contentsOf: newLots)
            self.lots.accept(updatedLots)
            self.fetchLotsInProccess.toggle()
        }
    }
}
