import Foundation
import Alamofire

public struct RemoteDataService {
    private static func baseHeaders() -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(HTTPHeader(name: "Content-Type", value: "application/json"))
        headers.add(HTTPHeader(name: "Accept", value: "application/json"))
//        headers.add(HTTPHeader(name: "authorization",
//        value: "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNjUyMjAyNTA3LCJleHAiOjE2NTIzNzUzMDd9.KYSYdSnMLQRfAzSrzr_36F-BBaxFxAMouYWxQ8p2ZPIC44q833dXvKnu487aL-K3RFGGXnOWqwokpv1lW3iZsQ"))
        if let accessHeader = TokenRefreshService.getAccessHeader() {
            headers.add(accessHeader)
        }
        return headers
    }

    // MARK: Метод обработки get запросов на бекенд
    public static func get<T: Codable>(
        url: String,
        dataType: T.Type,
        callback: @escaping ((Response) -> Void)) {

            AF.request(
                URL(string: url)!,
                method: .get,
                encoding: JSONEncoding.default,
                headers: baseHeaders()
            ).response { res in

                let processedReponse = RemoteDataService.baseProcessResponse(dataType, res)
                callback(processedReponse)
            }
        }

    // MARK: Метод обработки post запросов на бекенд
    public static func post<T: Codable>(
        dataType: T.Type,
        url: String,
        params: [String: Any]? = nil,
        isReturnHeaders: Bool = false,
        callback: @escaping ((Response) -> Void)
    ) {

        AF.request(
            URL(string: url)!,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: baseHeaders()
        ).response { res in

            let processedReponse = RemoteDataService.baseProcessResponse(dataType, res)

            // Если обертка успех и необходимо вернуть заголовки, то делаем новую обертку
            guard let successResponse = processedReponse as? SuccessResponse<T>, isReturnHeaders else {
                callback(processedReponse)
                return
            }

            let updatedResponse = SuccessResponseWithHeaders(
                data: successResponse.data,
                headers: res.response!.headers
            )
            callback(updatedResponse)
        }
    }

    // MARK: Метод обработки delete запросов на бекенд
    public static func delete<T: Codable>(
        dataType: T.Type,
        url: String,
        params: [String: Any]? = nil,
        callback: @escaping ((Response) -> Void)
    ) {

        AF.request(
            URL(string: url)!,
            method: .delete,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: baseHeaders()
        ).response { res in

            let processedReponse = RemoteDataService.baseProcessResponse(dataType, res)
            callback(processedReponse)
        }
    }

    // MARK: Метод обработки put запросов на бекенд
    public static func put<T: Codable>(
        dataType: T.Type,
        url: String,
        params: [String: Any]?,
        callback: @escaping ((Response) -> Void)
    ) {

        AF.request(
            URL(string: url)!,
            method: .put,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: baseHeaders()
        ).response { res in

            let processedReponse = RemoteDataService.baseProcessResponse(dataType, res)
            callback(processedReponse)
        }
    }

    // MARK: Базовая часть обработки всех запросов с бекенда
    private static func baseProcessResponse<T: Codable>(
        _ dataType: T.Type,
        _ res: AFDataResponse<Data?>
    ) -> Response {

        // Проверка что с сервера пришел ответ, иначе ошибочная обертка ответа
        guard let response = res.response else {
            return ErrorResponse(status: 500, message: "Server is unavailable", description: nil)
        }

        // Проверка что код ответа лежит в диапозоне положительных кодов, иначе ошибочная обертка ответа
        guard response.statusCode <= HTTPStatus.PermanentRedirect.code(),
              response.statusCode >= HTTPStatus.OK.code() else {
                  do {
                      return try JSONDecoder().decode(ErrorResponse.self, from: res.data!)
                  } catch { fatalError("") }
              }

        // Обработка положительного ответа относительно кода ответа
        switch response.statusCode {
            // Код ответа - без контента
        case HTTPStatus.Found.code(), HTTPStatus.NoContent.code():
            return SuccessResponse<Nothing>(data: Nothing.instance)

            // Код ответа - Обычный успех
        case HTTPStatus.OK.code(), HTTPStatus.Created.code():
            do {
                let decodedData = try JSONDecoder().decode(dataType, from: res.data!)
                return SuccessResponse<T>(data: decodedData)
            } catch { fatalError("") }
            // TODO: Не реализованные обработки на положительные коды ответа
        default:
            fatalError("Handler for code:\(response.statusCode) not implemented")
        }
    }

    public static func getNoRedirect<T: Codable> (
        dataType: T.Type,
        url: URL,
        fingerPrint: String,
        callback: @escaping ((Response) -> Void)
    ) {
        var headers = baseHeaders()
        headers.add(name: "oauth_fingerprint", value: fingerPrint)

        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)

        request.redirect(using: .doNotFollow)

        request.response { res in
            let processedReponse = RemoteDataService.baseProcessResponse(dataType, res)
            // Если обертка успех и необходимо вернуть заголовки, то делаем новую обертку
            guard let successResponse = processedReponse as? SuccessResponse<T> else { return }
            let updatedResponse = SuccessResponseWithHeaders(data: successResponse.data, headers: res.response!.headers)
            callback(updatedResponse)
        }
    }
    
    public static func uploadImage<T: Codable>(
        dataType: T.Type,
        imageData: Data,
        url: String,
        param: String,
        callback: @escaping ((Response) -> Void)) {
            
            AF.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData, withName: param, fileName: "image.jpeg", mimeType: "image/jpeg")
            }, to: url, method: .post, headers: baseHeaders()).response {  res in
                let processedReponse = RemoteDataService.baseProcessResponse(dataType, res)
                guard let successResponse = processedReponse as? SuccessResponse<T> else { return }
                callback(successResponse)
            }
        }
}
