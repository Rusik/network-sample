//
//  main.swift
//  Network
//
//  Created by Ruslan Kavetsky on 24.02.2020.
//  Copyright © 2020 Ruslan Kavetsky. All rights reserved.
//

import Foundation

protocol JSONDecoderProvider {}
extension JSONDecoderProvider {
    func jsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    func createEndpoint<Response: Decodable>(
        method: Method,
        path: String,
        parameters: Parameters? = nil) -> Endpoint<Response>
    {
        return Endpoint(
            method: method,
            path: path,
            parameters: parameters,
            decoder: jsonDecoder())
    }
}

class MenuService: JSONDecoderProvider {

    struct Menu: Decodable {}

    // DI
    let client = Client(baseURL: URL(string: "")!)
    let jsonDecoder: JSONDecoder = JSONDecoder()

    func getMenu() {
        var endpoint: Endpoint<Menu>
        // Создаём явно в теле функции
        endpoint = Endpoint(method: .get, path: "/menu", decoder: JSONDecoder())
        // Берём из инджекнутого проперти
        endpoint = Endpoint(method: .get, path: "/menu", decoder: self.jsonDecoder)
        // Берём из протокола JSONDecoderProvider
        endpoint = Endpoint(method: .get, path: "/menu", decoder: self.jsonDecoder())
        // Создаём через хэлпер из протокола JSONDecoderProvider
        endpoint = createEndpoint(method: .get, path: "/menu")

        client.request(endpoint) {
            let menu = try! $0.get()
            print(menu)
        }
    }

    func postOrder() {
        client.request(Endpoint(method: .post, path: "/order")) { _ in
            // Done
        }
    }
}

protocol JSONDecoderProvider_Static {}
extension JSONDecoderProvider_Static {
    static func jsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

class ProfileService: JSONDecoderProvider_Static {
    let client = Client(baseURL: URL(string: "")!)
    let jsonDecoder = JSONDecoder()

    struct Profile: Decodable {
        typealias Id = Int
    }
    struct Orders: Decodable {}

    // Option 1
    private enum Endpoints_staticFunctions {
        static func getProfile(id: Profile.Id) -> Endpoint<Profile> {
            Endpoint(method: .get, path: "/profile", parameters: ["id": id], decoder: jsonDecoder())
        }
        static func createOrder() -> Endpoint<Orders> {
            Endpoint(method: .post, path: "/orders", decoder: jsonDecoder())
        }
    }

    // Option 2
    private enum Endpoints_var {
// Can't do
//        static var getProfile: Endpoint<Profile> {
//            Endpoint(method: .get, path: "/profile", decoder: jsonDecoder())
//        }
        static var createOrder: Endpoint<Orders> {
            Endpoint(method: .get, path: "/orders", decoder: jsonDecoder())
        }
    }

    // Option 3
// Can't do
//    private let profileEndpoint = Endpoint<Profile>(method: .get, path: "/profile", decoder: jsonDecoder())
    private let ordersEndpoint = Endpoint<Orders>(method: .get, path: "/orders", decoder: jsonDecoder())

    // Option 4
    static func getProfile(id: Profile.Id) -> Endpoint<Profile> {
        Endpoint(method: .get, path: "/profile", parameters: ["id": id], decoder: jsonDecoder())
    }
    // Option 5
    func getProfile(id: Profile.Id) -> Endpoint<Profile> {
        Endpoint(method: .get, path: "/profile", parameters: ["id": id], decoder: jsonDecoder)
    }

    // ----

    func getProfile_withEndpoints(id: Profile.Id) {
        self.client.request(Endpoints_staticFunctions.getProfile(id: id)) {
            let profile = try! $0.get()
            print(profile)
        }
//        self.client.request(Endpoints_var.getProfile) {
//            let profile = try! $0.get()
//            print(profile)
//        }
        self.client.request(getProfile(id: id), completion: { _ in })
        self.client.request(Self.getProfile(id: id), completion: { _ in })
    }

    func getProfile_inline(id: Profile.Id) {
        let endpoint = Endpoint<Profile>(method: .get, path: "/profile", parameters: ["id": id], decoder: Self.jsonDecoder())
        self.client.request(endpoint) {
            let profile = try! $0.get()
            print(profile)
        }

        // Как тут указать тип респонса?
        // self.client.get(path: "/profile", params: ["id": id]) { result in
        //     ???
        // }
        // Так?
        // self.client.get<Profile>(path: "/profile", params: ["id": id])

//        self.client.request(self.profileEndpoint) {
//            let profile = try! $0.get()
//            print(profile)
//        }
    }

}

//MARK: - Main

func main() {
    MenuService().getMenu()
}

main()

//MARK: - Main 2
class Cllient {
    func get<Response>(path: String, decode: (Data) -> Response, completion: (Response) -> Void) {
        completion(decode(Data()))
    }
    func get<Response: Decodable>(path: String, decoder: JSONDecoder, completion: (Response) -> Void) {
        completion(try! decoder.decode(Response.self, from: Data()))
    }
}

class Seervice {
    let client = Cllient()

    struct Menu: Decodable {}

    // 3. С другой стороны внутри сервиса тип Menu неявно выводится из объявления функции getMenu
    func getMenu(completion: (Menu) -> Void) {
        self.client.get(path: "/menu", decoder: JSONDecoder(), completion: completion)
    }
}

func main2() {
    // 1. Не очень удобно записывать что мы получаем в виде респонса
    Cllient().get(path: "", decoder: JSONDecoder()) { (menu: ProfileService.Profile) in
        print(menu)
    }

    // 2. Потому что так не компилируется
//    Cllient().get<ProfileService.Profile>(path: "", decoder: JSONDecoder()) {
//        print(menu)
//    }
}

main2()

//MARK: - RunLoop
RunLoop.main.run()
