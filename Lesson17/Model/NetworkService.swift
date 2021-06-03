//
//  NetworkService.swift
//  Lesson17
//
//  Created by Алексей Алексеев on 02.06.2021.
//

import Foundation

enum NetworkServiceError: Error {
    case badUrl
    case network(str: String)
    case decodable
    case unknown
}

protocol NetworkServiceProtocol {
    func getWeather(for city: City, complete: @escaping (Result<ServerWeather, NetworkServiceError>) -> Void)
}

class NetworkService {
    private let session: URLSession = .shared
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

//MARK: - NetworkServiceProtocol

extension NetworkService: NetworkServiceProtocol {
    
    func getWeather(for city: City, complete: @escaping (Result<ServerWeather, NetworkServiceError>) -> Void) {
        var components = URLComponents(string: Constants.YandexAPIMetods.getWeather)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(city.latitude)),
            URLQueryItem(name: "lon", value: String(city.longitude)),
            URLQueryItem(name: "lang", value: "ru_RU"),
        ]
        
        guard let url = components?.url else { complete(.failure(.badUrl)); return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(Constants.YandexKeys.XYandexAPIKey, forHTTPHeaderField: "X-Yandex-API-Key")
        
        session.dataTask(with: request) { (data, response, error) in
            if let error = error { complete(.failure(.network(str: error.localizedDescription))); return }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode),
                  let data = data else { complete(.failure(.unknown)); return }
            do {
                let serverWeather = try self.decoder.decode(ServerWeather.self, from: data)
                complete(.success(serverWeather))
            } catch {
                complete(.failure(.decodable))
            }
        }.resume()
    }
}
