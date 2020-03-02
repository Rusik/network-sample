import Foundation
import Alamofire

final class AlamofireClient3 {

    let baseUrl: String
    let jsonDecoder: JSONDecoder
    private let session: Session

    enum NetworkError: Error {
        case underlying(_ error: Error)
        case unknownError
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
    }

    //MARK: - Get

    func get<Response: Decodable>(
        _ response: Response.Type,
        path: String,
        parameters: [String: Any],
        completion: @escaping (Result<Response, NetworkError>) -> Void)
    {
        let url = try! baseUrl.asURL().appendingPathComponent(path)
        let request = self.session.request(url, method: .get, parameters: parameters)
        self.response(request, completion: completion)
    }

    func get<Parameters: Encodable, Response: Decodable>(
        _ response: Response.Type,
        path: String,
        parameters: Parameters,
        completion: @escaping (Result<Response, NetworkError>) -> Void)
    {
        let url = try! baseUrl.asURL().appendingPathComponent(path)
        let request = self.session.request(url, method: .get, parameters: parameters)
        self.response(request, completion: completion)
    }

    func get<Parameters: Encodable>(
        path: String,
        parameters: Parameters,
        completion: @escaping (Result<Void, NetworkError>) -> Void)
    {
        let url = try! baseUrl.asURL().appendingPathComponent(path)
        let request = self.session.request(url, method: .get, parameters: parameters)
        self.response(request, completion: completion)
    }

//    //MARK: - Post
//
//    func post<Response: Decodable, Payload: Encodable>(
//        path: String,
//        payload: Payload,
//        completion: @escaping (Result<Response, NetworkError>) -> Void)
//    {
//        let url = try! baseUrl.asURL().appendingPathComponent(path)
//        let request = self.session.request(url, method: .get, parameters: payload)
//        self.response(request, completion: completion)
//    }
//
//    func post<Payload: Encodable>(
//        path: String,
//        payload: Payload,
//        completion: @escaping (Result<Void, NetworkError>) -> Void)
//    {
//        let url = try! baseUrl.asURL().appendingPathComponent(path)
//        let request = self.session.request(url, method: .get, parameters: payload)
//        self.response(request, completion: completion)
//    }

    //MARK: - Private

    private func response<Response: Decodable>(
        _ request: DataRequest,
        completion: @escaping (Result<Response, NetworkError>) -> Void)
    {
        request.responseDecodable(of: Response.self, decoder: self.jsonDecoder) { response in
            if let value = response.value {
                completion(.success(value))
            } else if let error = response.error?.underlyingError {
                completion(.failure(.underlying(error)))
            } else {
                completion(.failure(.unknownError))
            }
        }
    }

    private func response(
        _ request: DataRequest,
        completion: @escaping (Result<Void, NetworkError>) -> Void)
    {
        request.response() { response in
            if response.value != nil {
                completion(.success(()))
            } else if let error = response.error?.underlyingError {
                completion(.failure(.underlying(error)))
            } else {
                completion(.failure(.unknownError))
            }
        }
    }
}

//func foo() {
//    AlamofireClient3(baseUrl: "").get(Menu.self, path: "", parameters: [:]) { result in
//        let _: Menu = try! result.get()
//    }
//    AlamofireClient3(baseUrl: "").get(Void.self, path: "", parameters: [:]) { result in
//        let _: Menu = try! result.get()
//    }
//}
