import Foundation

enum HttpParameter {
    case bool(Bool)
    case int(Int)
    case float(Float)
    case string(String)
}

extension HttpParameter: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension HttpParameter: ExpressibleByFloatLiteral {
    init(floatLiteral value: Float) {
        self = .float(value)
    }
}

extension HttpParameter: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

extension HttpParameter: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self = .int(value)
    }
}

func test() {
    let _: HttpParameter = "hello"
    let _: HttpParameter = 123
    let _: HttpParameter = 1.23
    let _: HttpParameter = false
}
