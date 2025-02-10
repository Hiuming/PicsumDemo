
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//

import Foundation

enum PicsumAPIRouter: APIInputBase {
    case getImage(page: Int)
}

extension PicsumAPIRouter {
    var baseURL: String {
        return "https://picsum.photos/v2/list"
    }
    
    var url: URL {
        switch self {
        case .getImage:
            var query: [URLQueryItem] = []
            for (k,v) in parameters {
                query.append(URLQueryItem(name: k, value: v))
            }
            var url = URLComponents(string: baseURL)!
            url.queryItems = query
            if let url = url.url  { return url } else {
                return URL(string: baseURL)!
            }
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String : String] {
        switch self {
        case .getImage(let page):
            return [
                "page" : String(page),
                "limit" : "100"
            ]
        }
    }
}

