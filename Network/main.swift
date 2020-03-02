import Foundation
import Alamofire

//let baseUrl = "https://postb.in/1583084070077-2660918331239"
let baseUrl = "https://postb.in/1583138944044-2034885881002"
//let baseUrl = "https://postb.in/1583138180711-1321108536794"
foo4()

//struct Params: Codable {
//    let hello: String
//}

//let client = Client(baseURL: URL(string: baseUrl)!)
//client.request(Endpoint<Void>(method: .get, path: "client", parameters: nil)) { result in
//    switch result {
//    case .success:
//        print("Yo")
//    case .failure(let error):
//        print(error)
//    }
//}

//final class AlamofireClient {
//
//    let baseUrl: String
//    let jsonDecoder: JSONDecoder
//    private let session: Session
//
//    init(baseUrl: String, jsonDecoder: JSONDecoder = JSONDecoder()) {
//        self.baseUrl = baseUrl
//        self.jsonDecoder = jsonDecoder
//        self.session = Session.default
//    }
//
//    func get<Response: Decodable>(
//        path: String,
//        parameters: [String: Any],
//        completion: @escaping (Response?) -> Void)
//    {
//        let url = try! baseUrl.asURL().appendingPathComponent(path)
//        let request = self.session.request(url, method: .get, parameters: parameters)
//        self.response(request, completion: completion)
//
////        self.session
////            .request(url, method: .get, parameters: parameters)
////            .responseDecodable(of: Response.self, decoder: self.jsonDecoder) { response in
////                completion(response.value)
////        }
//    }
//
//    func get<Response: Decodable, Parameters: Encodable>(
//        path: String,
//        parameters: Parameters,
//        completion: @escaping (Response?) -> Void)
//    {
//        let url = try! baseUrl.asURL().appendingPathComponent(path)
//        let request = self.session.request(url, method: .get, parameters: parameters)
//        self.response(request, completion: completion)
//
////        self.session
////            .request(url, method: .get, parameters: parameters)
////            .responseDecodable(of: Response.self, decoder: self.jsonDecoder) { response in
////                completion(response.value)
////        }
//    }
//
//    func post<Response: Decodable, Payload: Encodable>(
//        path: String,
//        payload: Payload,
//        completion: @escaping (Response?) -> Void)
//    {
//        let url = try! baseUrl.asURL().appendingPathComponent(path)
//        let request = self.session.request(url, method: .get, parameters: payload)
//        self.response(request, completion: completion)
//
////        self.session
////            .request(url, method: .get, parameters: payload)
////            .responseDecodable(of: Response.self, decoder: self.jsonDecoder) { response in
////                completion(response.value)
////        }
//    }
//
//    func post<Payload: Encodable>(
//        path: String,
//        payload: Payload,
//        completion: @escaping () -> Void)
//    {
////        let url = try! baseUrl.asURL().appendingPathComponent(path)
////        let request = self.session.request(url, method: .get, parameters: payload)
////        request
////        self.response(request) { (d: Void?) in
////            completion()
////        }
//
////        self.session
////            .request(url, method: .get, parameters: payload)
////            .responseDecodable(of: Response.self, decoder: self.jsonDecoder) { response in
////                completion(response.value)
////        }
//    }
//
//    private func response<Response: Decodable>(_ request: DataRequest, completion: @escaping (Response?) -> Void) {
//        request.responseDecodable(of: Response.self, decoder: self.jsonDecoder) { response in
//            completion(response.value)
//        }
//    }
//}

struct Menu: Decodable {
    let items: [String]
}

//let client = AlamofireClient(baseUrl: "https://hookb.in/eKZREjD7KaFr9g86QG3R")
//client.get(path: "111", parameters: ["asd": 11]) { (result: Result<Menu, AlamofireClient.NetworkError> ) in
//    print(result)
//}

struct Person: Encodable {
    let name: String
}

//client.post(path: "222", payload: Person(name: "Ruslan")) { (d: Void?) in
//    print(d)
//}

//JSONParameterEncoder

//AF.request(baseUrl, method: .get, parameters: ["hello2": "world2"]).response {
//    debugPrint($0)
//}


//AF.request(baseUrl, method: .get, parameters: Params(hello: "world")).response {
//    debugPrint($0)
//}

//AF.request(baseUrl, method: .get, parameters: Params(hello: "world"), encoder: JSONParameterEncoder(), headers: nil, interceptor: nil).response { response in
//    debugPrint($0)
//}

// protocol URLRequestConvertible
// struct RequestConvertible: URLRequestConvertible
// struct RequestEncodableConvertible<Parameters: Encodable>: URLRequestConvertible
// struct ParameterlessRequestConvertible: URLRequestConvertible


struct RequestConvertible2: URLRequestConvertible {
    let url: URLConvertible
    let method: HTTPMethod
    let parameters: Parameters?
    let encoding: ParameterEncoding
    // func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest
    let headers: HTTPHeaders?

    func asURLRequest() throws -> URLRequest {
        let request = try URLRequest(url: url, method: method, headers: headers)
        return try encoding.encode(request, with: parameters)
    }
}

struct RequestEncodableConvertible2<Parameters: Encodable>: URLRequestConvertible {
    let url: URLConvertible
    let method: HTTPMethod
    let parameters: Parameters?
    let encoder: ParameterEncoder
    // func encode<Parameters: Encodable>(_ parameters: Parameters?, into request: URLRequest) throws -> URLRequest
    let headers: HTTPHeaders?

    func asURLRequest() throws -> URLRequest {
        let request = try URLRequest(url: url, method: method, headers: headers)
        return try parameters.map { try encoder.encode($0, into: request) } ?? request
    }
}

struct ParameterlessRequestConvertible2: URLRequestConvertible {
    let url: URLConvertible
    let method: HTTPMethod
    let headers: HTTPHeaders?

    func asURLRequest() throws -> URLRequest {
        return try URLRequest(url: url, method: method, headers: headers)
    }
}

RunLoop.main.run()
