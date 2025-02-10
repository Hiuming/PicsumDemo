//
//  ViewModel.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//

import Foundation
import UIKit

class PicsumViewModel {
    private var useCase: PicsumUseCaseType?
    var currentPage: Int = 1
    var count: Int = 0
    var photos: [PhotoModel] = []
    var filteredItems: [PhotoModel] = []
    var onFinishLoad: (() -> Void)?
    var onErrorFetching: ((NetworkError) -> Void)?
    var onSearchComplete: (() -> Void)?
    var onReachingPageLimit: (() -> Void)?
    var hasLoaded: Bool = false
    var isSearching: Bool = false
    var reachPageLimit: Bool = false {
        didSet {
            if reachPageLimit {
                onReachingPageLimit?()
            }
        }
    }
    var currentSearchText: String = "" {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.75) { [weak self] in
                guard let self = self else { return }
                self.filterItems(with: currentSearchText)
                self.onSearchComplete?()
            }
        }
    }
    
    init() {
        self.useCase = AppLocator.shared.resolve()
    }
    
    func fetchImageList() {
        useCase?.getPhoto(page: currentPage, completion: { [weak self]  photo, error in
            guard let self = self else { return }
            if let error = error {
                self.onErrorFetching?(error)
            } else if let photo = photo {
                if photo.isEmpty {
                    reachPageLimit = true
                    return
                }
                self.photos.append(contentsOf: photo)
                self.filterItems(with: self.currentSearchText)
                self.onFinishLoad?()
            }
        })
    }
    
    func filterItems(with searchText: String) {
        if searchText.isEmpty {
            filteredItems = self.photos
            self.count = self.filteredItems.count
        } else {
            let lowercasedSearchText = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            filteredItems = photos.filter { item in
                let authorMatch = item.author?.lowercased().contains(lowercasedSearchText) ?? false
                let idMatch = item.id == lowercasedSearchText
                return authorMatch || idMatch
            }
            self.count = self.filteredItems.count
        }
    }
    
    func item(at indexPath: IndexPath)  -> PhotoModel {
        guard indexPath.row < filteredItems.count else {
            fatalError("Index out of range in item(at:) \(indexPath.row) / \(filteredItems.count)")
        }
        return filteredItems[indexPath.row]
    }
    
    
    func eraseData() {
        currentPage = 1
        count = 0
        reachPageLimit = false
        photos.removeAll()
    }
    
    func loadMore() {
        currentPage += 1
        self.fetchImageList()
    }
    
    func validateSearchText(_ text: String) -> String {
        let validCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*():.,<>\\/[]?. ")
        let filteredText = String(text.unicodeScalars.filter { validCharacters.contains($0) })
        return String(filteredText.prefix(15))
    }
    
    
}
