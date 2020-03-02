import Foundation

typealias Parameters = [String: Any]
typealias Path = String

enum Method {
    case get, post, put, patch, delete
}

struct Endpoint<Response> {
    let method: Method
    let path: String
    let parameters: Parameters?
    let decode: (Data) throws -> Response

    init(method: Method,
         path: String,
         parameters: Parameters? = nil,
         decode: @escaping (Data) throws -> Response
    ) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.decode = decode
    }
}

extension Endpoint where Response: Decodable {
    init(method: Method,
         path: String,
         parameters: Parameters? = nil,
         decoder: JSONDecoder
    ) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.decode = { try decoder.decode(Response.self, from: $0) }
    }
}

extension Endpoint where Response == Void {
    init(method: Method,
         path: String,
         parameters: Parameters? = nil
    ) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.decode = { _ in }
    }
}

extension Endpoint where Response == Data {
    init(method: Method,
         path: String,
         parameters: Parameters? = nil
    ) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.decode = { $0 }
    }
}
