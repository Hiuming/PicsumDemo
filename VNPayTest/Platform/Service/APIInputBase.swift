
import Foundation
import Network

protocol APIInputBase {
    var url: URL { get }
    var method: HTTPMethod { get }
    var parameters: [String: String] { get }
}
