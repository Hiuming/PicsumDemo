//
//  PicsumRepository.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//


import Foundation
protocol PicsumRepositoryType {
    func getPhoto(page: Int, completion: @escaping([PhotoModel]?, NetworkError?) -> Void)
}

class PicsumRepository: PicsumRepositoryType {
    
    private let apiService: APIService = APIService.shared
    
    func getPhoto(page: Int, completion: @escaping([PhotoModel]?, NetworkError?) -> Void) {
        apiService.requestList(input: PicsumAPIRouter.getImage(page: page)) { (result: Result<[PhotoModel], NetworkError>) in
            switch result {
            case .success(let photoModels):
                return completion(photoModels,nil)
            case .failure(let error):
                return completion(nil,error)
            }
        }
    }
}


