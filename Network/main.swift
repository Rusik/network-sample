//
//  main.swift
//  Network
//
//  Created by Ruslan Kavetsky on 24.02.2020.
//  Copyright © 2020 Ruslan Kavetsky. All rights reserved.
//

import Foundation

struct Menu: Decodable {}
struct Cart: Decodable {}

func getMenu() -> Endpoint<Menu> {
    return Endpoint(method: .get, path: "/menu")
}

enum Endpoints {

// ⚠️ Not compile
//    case getMenu
//    case addToCard(id: String)
//
//    func endpoint<R>() -> Endpoint<R> { // AnyEndpoint needs here
//        switch self {
//        case .getMenu:
//            return Endpoint<Menu>(method: .get, path: "/menu")
//        case .addToCard(let id):
//            return Endpoint<Void>(method: .post, path: "/cart", parameters: ["id": id])
//        }
//    }

    static func getMenu() -> Endpoint<Menu> {
        Endpoint(method: .get, path: "/menu")
    }

    static func addToCard(id: String) -> Endpoint<Void> {
         Endpoint(method: .post, path: "/cart", parameters: ["id": id])
    }

    static func getCart() -> JsonEndpoint<Cart> {

        // Option 1
        // Create and assign custom decoder
        let decoder1 = JSONDecoder()
        decoder1.dateDecodingStrategy = .iso8601
        let endpoint1 = JsonEndpoint<Cart>(method: .get, path: "/cart", decoder: decoder1)

        // Option 2
        // Customize default decoder
        let endpoint2 = JsonEndpoint<Cart>(method: .get, path: "/cart")
        endpoint2.decoder.dateDecodingStrategy = .iso8601

        // Option 3
        // Get customized decoder from global static function
        _ = JsonEndpoint<Cart>(method: .get, path: "/cart", decoder: jsonDecoder())

        // Option 4
        // Function wrapper that creates json enpoints with customized decoder
        _ = jsonEndpoint(raw: Endpoint<Cart>(method: .get, path: "/cart"))

        // Option 5
        //
        _ = JsonEndpoint_(raw: Endpoint<Cart>(method: .get, path: "/cart"), decoder: jsonDecoder())

        // Option 6
        //
        _ = Endpoint<Cart>(method: .get, path: "/cart").jsonEndpoint()

        // Option 7
        //
        _ = Endpoint<Cart>(method: .get, path: "/cart").withJsonDecoder(jsonDecoder())

        // Option 8
        //
        _ = Endpoint<Cart>(method: .get, path: "/cart", parameters: nil, decode: jsonDecoderr())

        // Option 9
        //
        _ = Endpoint<Cart>(method: .get, path: "/cart", parameters: nil) {
            try jsonDecoder().decode(Cart.self, from: $0)
        }


        return endpoint1
    }

    private static func jsonEndpoint<R: Decodable>(raw: Endpoint<R>) -> Endpoint<R> {
        Endpoint(method: raw.method, path: raw.path, parameters: raw.parameters) {
            try jsonDecoder().decode(R.self, from: $0)
        }
    }

    private static func jsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    private static func jsonDecoderr<Response: Decodable>() -> (Data) throws -> Response {
        return {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(Response.self, from: $0)
        }
    }
}

extension Endpoint where Response: Decodable {
    func jsonEndpoint() -> Endpoint<Response> {
        Endpoint(method: method, path: path, parameters: parameters) {
            try JSONDecoder().decode(Response.self, from: $0)
        }
    }
}

class MenuService {
    private let apiClient = Client(baseURL: URL(string: "")!)

    enum Endpoints {
        static func getMenu() -> Endpoint<Menu> {
            Endpoint(method: .get, path: "/menu")
        }
        static func getCart() -> Endpoint<Cart> {
            Endpoint(method: .get, path: "/cart")
        }
    }

    func getMenu(completion: @escaping (Menu?) -> Void) {
        apiClient.request(Endpoints.getMenu()) { result in
            completion(try? result.get())
        }
    }

    func getCart(completion: @escaping (Cart?) -> Void) {
        apiClient.request(Endpoints.getCart()) { result in
            completion(try? result.get())
        }
    }
}

func main() {

    let baseUrl = URL(string: "")!
    let client = Client(baseURL: baseUrl)

    client.request(getMenu()) { result in
        let menu: Menu = try! result.get()
        print(menu)
    }

    client.request(Endpoints.addToCard(id: "123")) { result in
        switch result {
        case .success: ()
            // success
        case .failure: ()
            // failure
        }
    }
}

main()

RunLoop.main.run()
