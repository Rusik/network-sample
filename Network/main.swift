import Foundation
import Alamofire

let baseUrl = ""

let client = ApiClient(baseUrl: baseUrl)

struct Payload: Encodable {
    let id: Int
}

struct Menu: Decodable {}

//MARK: - Get
// Menu в респонсе, параметры как Encodable объект
client.request(Menu.self, method: .get, path: "menu", parameters: Payload(id: 1), completion: nil)
// Menu в респонсе, параметры как словарь
client.request(Menu.self, method: .get, path: "menu", parameters: ["dict_id": 1], completion: nil)
// Без респонса, параметры как Encodable объект
client.request(method: .get, path: "menu", parameters: ["dict_id_void": 1], completion: nil)
// Без респонса, параметры как словарь
client.request(method: .get, path: "menu", parameters: Payload(id: 1), completion: nil)

//MARK: - Post
client.request(Menu.self, method: .post, path: "order", parameters: Payload(id: 1), completion: nil)
client.request(Menu.self, method: .post, path: "order", parameters: ["dict_id": 1], completion: nil)
client.request(method: .post, path: "order", parameters: ["order_id": 1], completion: nil)
client.request(method: .post, path: "order", parameters: Payload(id: 1), completion: nil)

RunLoop.main.run()
