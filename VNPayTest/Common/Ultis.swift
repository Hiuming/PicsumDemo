//
//  Ultis.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//
import UIKit
import Foundation
class Ultis {
    static func createDownloadImageTaskAndCacheImage(url: String, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: url) else {
            completion(nil)
            return nil
        }
        
        if let cachedImage = ImageCached.shared.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Load image fail due to: \(error?.localizedDescription ?? "")")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                ImageCached.shared.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
        return task
    }
}
