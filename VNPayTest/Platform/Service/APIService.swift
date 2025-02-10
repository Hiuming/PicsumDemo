//
//  APIService.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//


import Foundation

final class APIService {
    public static let shared = APIService()
    
    //normal request here
    
    //list request
    public func requestList<T: Codable> (input: APIInputBase, completion: @escaping(Result<[T], NetworkError>) -> Void) {
        
        var request = URLRequest(url: input.url)
        request.httpMethod = input.method.rawValue
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load data: \(error?.localizedDescription ?? "No error description")")
                completion(.failure(.IncorrectDataReturned))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 400 {
                completion(.failure(.NotReachedServer))
            }
            
            do {
                let decodedItems = try JSONDecoder().decode([T].self, from: data)
                completion(.success(decodedItems))
            } catch {
                completion(.failure(.IncorrectDataReturned))
            }
            
            
        }
        task.resume()
    }
}




