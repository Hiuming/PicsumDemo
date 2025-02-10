//
//  ServiceLocator.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//
import Foundation
protocol LocatorType {
    func resolve<T>() -> T?
}

final class Locator: LocatorType {
    private var services: [ObjectIdentifier: Any] = [:]
    
    func register<T>(_ service: T) {
        services[key(for: T.self)] = service
    }
    
    func resolve<T>() -> T? {
        return services[key(for: T.self)] as? T
    }

    private func key<T>(for type: T.Type) -> ObjectIdentifier {
        return ObjectIdentifier(T.self)
    }
}
