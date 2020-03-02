import Foundation
import Alamofire

final class ApiClient {

    let baseUrl: String
    let jsonDecoder: JSONDecoder
    private let session: Session

    //MARK: - Types

    enum Error: Swift.Error {
        case underlying(_ error: Swift.Error)
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

    typealias Completion<Response> = (Result<Response, Error>) -> Void

    //MARK: - Init

    init(baseUrl: String, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.baseUrl = baseUrl
        self.jsonDecoder = jsonDecoder
        self.session = Session.default
        // Убрал кэширования для корректного тестирования get запросов
        self.session.sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    }

    //MARK: - Get

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
            } else if let error = response.error?.underlyingError {
                completion?(.failure(.underlying(error)))
            } else {
                completion?(.failure(.unknownError))
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
            } else if let error = response.error?.underlyingError {
                completion?(.failure(.underlying(error)))
            } else {
                completion?(.failure(.unknownError))
            }
        }
    }
}
