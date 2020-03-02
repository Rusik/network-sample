import Foundation
import Alamofire

//typealias ResultCompletion<Value, Error> = (Result<Value, Error>) -> Void

protocol ClientProtocol {
    associatedtype ClientError: Swift.Error

    func request<Response>(
       _ endpoint: Endpoint<Response>,
       completion: @escaping (Result<Response, ClientError>) -> Void
    )
}

final class Client: ClientProtocol {

    enum ClientError: Error {
        case parseError(Error)
        case networkError(Error)
        case unknown
    }

    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

     func request<Response>(
        _ endpoint: Endpoint<Response>,
        completion: @escaping (Result<Response, ClientError>) -> Void)
     {

        URLSession.shared.dataTask(with: self.baseURL.appendingPathComponent(endpoint.path)) { (data, _, error) in
            let result: Result<Response, ClientError>
            if let data = data {
                do {
                    let response = try endpoint.decode(data)
                    result = .success(response)
                } catch {
                    result = .failure(ClientError.parseError(error))
                }
            } else if let error = error {
                result = .failure(ClientError.networkError(error))
            } else {
                result = .failure(ClientError.unknown)
            }
            completion(result)
        }.resume()
    }
}
