//
//  APIClient.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/18.
//

import Foundation
import Combine

protocol APIClient {
    var baseURL: String { get }
    func perform<T: Serializable>(request: Request, path: String, properties: [String: Any]?) -> AnyPublisher<T, Error>
}


final class YamAPIClient: APIClient {
    private let defaultSession = URLSession(configuration: .default)
    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func perform<T: Serializable>(request: Request, path: String, properties: [String: Any]?) -> AnyPublisher<T, Error> {
        guard let url = URL(string: baseURL + path) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        return defaultSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { try T.decode($0) }
            .eraseToAnyPublisher()
    }
}
