//
//  PicsumUseCase.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//

import Foundation

protocol PicsumUseCaseType {
    func getPhoto(page: Int, completion: @escaping([PhotoModel]?, NetworkError?) -> Void)
}

class PicsumUseCase: PicsumUseCaseType {
    var repository: PicsumRepositoryType?
    
    init() {
        self.repository = AppLocator.shared.resolve()
    }
    
    func getPhoto(page: Int, completion: @escaping([PhotoModel]?, NetworkError?) -> Void){
        repository?.getPhoto(page: page, completion: completion)
    }
}
