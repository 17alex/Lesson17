//
//  ViewController.swift
//  Lesson17
//
//  Created by Алексей Алексеев on 02.06.2021.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Propertis
    
    private let networkService: NetworkServiceProtocol
    private var weathers: [Weather] = []
    private let cities: [City] = [
        City(name: "Moscow", latitude: 55.672222, longitude: 37.761196),
        City(name: "Piter", latitude: 59.926146, longitude: 30.347374),
        City(name: "Murmansk", latitude: 68.968904, longitude: 33.093198),
        City(name: "Norilsk", latitude: 69.344401, longitude: 88.211762),
    ]
    
    private lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.register(CityCell.self, forCellReuseIdentifier: CityCell.reuseID)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - Init
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LiceCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        cities.forEach { city in
            weathers.append(Weather(name: city.name, description: "loading..."))
        }
        
        cities.forEach { city in
            self.networkService.getWeather(for: city) { result in
                DispatchQueue.main.async { self.handleResult(result, for: city) }
            }
        }
    }
    
    //MARF: - Metods
    
    private func handleResult(_ result: Result<ServerWeather, NetworkServiceError>, for city: City) {
        let cityIndex = self.weathers.firstIndex { $0.name == city.name }
        if let index = cityIndex {
            switch result {
            case .failure(let error):
                self.weathers[index].description = self.message(error)
            case .success(let serverWeather):
                let fact = serverWeather.fact
                self.weathers[index].description = "\(fact.condition), \(fact.windSpeed)mm/s, \(fact.windDir), \(fact.pressureMm)mm, \(fact.humidity)%,  \(fact.temp)℃"
            }
            self.table.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    private func message(_ error: NetworkServiceError) -> String {
        switch error {
        case .badUrl: return "bad url"
        case .network(str: let str): return str
        case .decodable: return "decode error"
        case .unknown: return "unknown error"
        }
    }
    
    private func setupUI() {
        title = "Weather"
        view.backgroundColor = .systemBackground
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.reuseID, for: indexPath) as! CityCell
        cell.set(weather: weathers[indexPath.row])
        return cell
    }
}
