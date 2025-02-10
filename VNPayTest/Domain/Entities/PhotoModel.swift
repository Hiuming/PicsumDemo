//
//  PhotoModel.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//

import Foundation

class PhotoModel: Codable {
    let id: String?
    let author: String?
    let width: Int?
    let height: Int?
    let url: String?
    let downloadUrl: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case author = "author"
        case width = "width"
        case height = "height"
        case url = "url"
        case downloadUrl = "download_url"
    }

    init(id: String?, author: String?, width: Int?, height: Int?, url: String?, downloadUrl: String?) {
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.url = url
        self.downloadUrl = downloadUrl
    }
}
