import Foundation

typealias Parameters = [String: Any]
typealias Path = String

enum Method {
    case get, post, put, patch, delete
}

protocol EndpointProtocol {
    associatedtype Response
    var method: Method { get }
    var path: Path  { get }
    var parameters: Parameters?  { get }
    var decode: (Data) throws -> Response { get }
}

struct Endpoint<Response>: EndpointProtocol {
    let method: Method
    let path: String
    let parameters: [String: Any]?
    let decode: (Data) throws -> Response
}

// option 1
struct JsonEndpoint<Response>: EndpointProtocol where Response: Swift.Decodable {
    let method: Method
    let path: String
    let parameters: [String: Any]?
    let decode: (Data) throws -> Response
    let decoder: JSONDecoder // allow to customize decodingStrategies

    init(method: Method = .get,
         path: Path,
         parameters: Parameters? = nil,
         decoder: JSONDecoder = JSONDecoder())
    {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.decoder = decoder
        self.decode = { try decoder.decode(Response.self, from: $0) }
    }
}

// option 3
func JsonEndpoint_<Response: Decodable>(raw: Endpoint<Response>, decoder: JSONDecoder) -> Endpoint<Response> {
    Endpoint(method: raw.method, path: raw.path, parameters: raw.parameters) {
        try decoder.decode(Response.self, from: $0)
    }
}

// option 4
extension Endpoint where Response: Decodable {
    func withJsonDecoder(_ decoder: JSONDecoder) -> Endpoint {
        Endpoint(method: method, path: path, parameters: parameters) {
            try decoder.decode(Response.self, from: $0)
        }
    }
}

// option 2
extension Endpoint where Response: Swift.Decodable {
    init(method: Method = .get,
         path: Path,
         parameters: Parameters? = nil)
    {
        self.init(method: method,
                  path: path,
                  parameters: parameters,
                  decode: { try JSONDecoder().decode(Response.self, from: $0) }
        )
    }
}

extension Endpoint where Response == Void {
    init(method: Method = .get,
         path: Path,
         parameters: Parameters? = nil)
    {
        self.init(method: method,
                  path: path,
                  parameters: parameters,
                  decode: { _ in () }
        )
    }
}

//MARK: -
//
//enum Scope {
//    enum Guest {}
//    enum Customer {}
//}
//
//struct AuthorizedEndpoint<Response, Auth> {
//    let raw: Endpoint<Response>
//}
//
//struct AuthorizedClient<Auth> {
//    fileprivate let raw: Client
//    init(raw: Client) { self.raw = raw }
//}
//
//extension AuthorizedClient where Auth == Scope.Guest {
//
//
//    func request<Response>(_ endpoint: AuthorizedEndpoint<Response, Auth>, completion: @escaping (Result<Response, Client.ClientError>) -> Void) {
//
//    }
//
//
//    func request<Endpoint: EndpointProtocol>(_ endpoint: Endpoint, completion: @escaping (Result<Endpoint.Response, ClientError>)
//
//    func request<Response>(_ endpoint: AuthorizedEndpoint<Scope.Guest, Response>) -> Single<Response> {
//        return raw.request(endpoint.raw)
//    }
//}
//
//extension AuthorizedClient where Authorization == Scope.Customer {
//    func request<Response>(_ endpoint: AuthorizedEndpoint<Scope.Guest, Response>) -> Single<Response> {
//        return raw.request(endpoint.raw)
//    }
//
//    func request<Response>(_ endpoint: AuthorizedEndpoint<Scope.Customer, Response>) -> Single<Response> {
//        return raw.request(endpoint.raw)
//    }
//}
