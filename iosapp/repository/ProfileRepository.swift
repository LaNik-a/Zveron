//
//  ProfileRepository.swift
//  iosapp
//
//  Created by alexander on 17.04.2022.
//

import Foundation
import RemoteDataService

class ProfileRepository {

    func getUserInfo(callback: @escaping (Response) -> Void) {
        let url = ""
        RemoteDataService.get(url: url, dataType: Profile.self, callback: callback)
    }

    func editUserInfo(
        name: String,
        surname: String,
        imageId: Int,
        callback: @escaping (Response) -> Void
    ) {
        let url = ""
        let params: [String: Any] = [
            "name": name,
            "surname": surname,
            "imageId": imageId
        ]
        RemoteDataService.post(dataType: Profile.self, url: url, params: params, callback: callback)
    }

}
