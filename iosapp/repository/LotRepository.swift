//
//  LotRepository.swift
//  iosapp
//


import Foundation
import RemoteDataService
import UIKit

class LotRepository {
    func getLots(
        request: RequestLotDto,
        callback: @escaping (Response) -> Void
    ) {
        var url = "\(RemoteDataConstant.BASE_URL)/lots?pageSize=\(request.pageSize)"
        
        if let lastId = request.lotId, let lastDateOfPublish = request.dateCreationLot {
            url += "&lotId=\(lastId)&dateCreationLot=\(lastDateOfPublish)"
            
        }
        
        RemoteDataService.get(url: url, dataType: FailableCodableArray<MiniLot> .self, callback: callback)
    }
    
    func getLot(
        lotId: Int,
        callback: @escaping (Response) -> Void
    ) {
        let url = "\(RemoteDataConstant.BASE_URL)/lots/\(lotId)"
        RemoteDataService.get(url: url, dataType: CardLotPreview.self, callback: callback)
    }
    
    func setLot(
        lot: Lot,
        callback: @escaping (Response) -> Void) {
            let url = "\(RemoteDataConstant.BASE_URL)/api/lot"
            do {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(lot)
                let params = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                guard let params = params as? [String:Any] else { return }
                RemoteDataService.post(dataType: Nothing.self, url: url, params: params, callback: callback)
            } catch {
                print("Ошибка при парсинге параметров запроса в Json формат")
            }
            
        }
    
    func uploadImageLot(
        image: UIImage,
        callback: @escaping (Response) -> Void) {
            let url = "\(RemoteDataConstant.BASE_URL)/api/data/photo"
            let imageData = image.jpegData(compressionQuality: 0.50)
            guard let imageData = imageData else { return }
            RemoteDataService.uploadImage(dataType: PhotoId.self, imageData: imageData, url: url, param: "multipartImage", callback: callback)
        }
    
    
    // в будущем надо еще лот айди передавать
    func getLotParameters(
        categoryId: Int,
        callback: @escaping (Response) -> Void
    ){
        let url = "\(RemoteDataConstant.BASE_URL)/lots/parameters?id_category=\(categoryId)&id_lot_form=1"
        
        RemoteDataService.get(url: url, dataType: FailableCodableArray<LotParameter>.self, callback: callback)
    }
}
