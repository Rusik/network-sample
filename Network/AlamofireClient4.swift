import Foundation
import Alamofire

final class AlamofireClient4 {

    let baseUrl: String
    let jsonDecoder: JSONDecoder
    private let session: Session

    enum NetworkError: Error {
        case underlying(_ error: Error)
        case unknownError
    }

    enum Method {
        case get, post
        var httpMethod: HTTPMethod {
            switch self {
            case .post:
                return .post
            case .get:
                return .get
            }
        }
    }

    /*
     Get запрос
     Параметры: Словарь | Encodable | nil
     Результат: Void | Decodable
     */

    init(baseUrl: String, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.baseUrl = baseUrl
        self.jsonDecoder = jsonDecoder
        self.session = Session.default
        self.session.sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    }

    //MARK: - Get

    typealias Completion<Response> = (Result<Response, NetworkError>) -> Void

    func request<Response: Decodable>(
        _ response: Response.Type,
        method: Method,
        path: String,
        parameters: [String: Any],
        completion: Completion<Response>?)
    {
        let url = try! baseUrl.asURL().appendingPathComponent(path)
        let request = self.session.request(url, method: method.httpMethod, parameters: parameters)
        self.response(request, completion: completion)
    }

    func request<Parameters: Encodable, Response: Decodable>(
        _ response: Response.Type,
        method: Method,
        path: String,
        parameters: Parameters,
        completion: Completion<Response>?)
    {
        let url = try! baseUrl.asURL().appendingPathComponent(path)
        let request = self.session.request(url, method: method.httpMethod, parameters: parameters)
        self.response(request, completion: completion)
    }

    func request<Parameters: Encodable>(
        method: Method,
        path: String,
        parameters: Parameters,
        completion: Completion<Void>?)
    {
        let url = try! baseUrl.asURL().appendingPathComponent(path)
        let request = self.session.request(url, method: method.httpMethod, parameters: parameters)
        self.response(request, completion: completion)
    }

    //MARK: - Private

    private func response<Response: Decodable>(
        _ request: DataRequest,
        completion: Completion<Response>?)
    {
        request.responseDecodable(of: Response.self, decoder: self.jsonDecoder) { response in
            if let value = response.value {
                completion?(.success(value))
                print(value)
            } else if let error = response.error?.underlyingError {
                completion?(.failure(.underlying(error)))
                print(error)
            } else {
                completion?(.failure(.unknownError))
                print("unknown")
            }
        }
    }

    private func response(
        _ request: DataRequest,
        completion: Completion<Void>?)
    {
        request.response() { response in
            if response.value != nil {
                completion?(.success(()))
                print("success")
            } else if let error = response.error?.underlyingError {
                completion?(.failure(.underlying(error)))
                print(error)
            } else {
                completion?(.failure(.unknownError))
                print("unknown")
            }
        }
    }
}

let client = AlamofireClient4(baseUrl: baseUrl)

func foo4() {

//    let client = AlamofireClient4(baseUrl: baseUrl)

    struct Menu: Decodable {}
    struct Payload: Encodable {
        let id: Int
    }

//    AF.request(baseUrl).response {
//        debugPrint($0)
//    }

//    client.request(Menu.self, method: .get, path: "menu", parameters: Payload(id: 1), completion: nil)
//    client.request(Menu.self, method: .get, path: "menu", parameters: ["dict_id": 1], completion: nil)
//    client.request(method: .get, path: "menu", parameters: ["dict_id_void": 1], completion: nil)
//    client.request(method: .get, path: "menu", parameters: Payload(id: 1), completion: nil)
//
//    client.request(method: .post, path: "order", parameters: ["order_id": 1], completion: nil)
//    client.request(method: .post, path: "order", parameters: Payload(id: 1), completion: nil)
//    client.request(Menu.self, method: .post, path: "order", parameters: ["dict_id": 1], completion: nil)
//    client.request(Menu.self, method: .post, path: "order", parameters: Payload(id: 1), completion: nil)
}
