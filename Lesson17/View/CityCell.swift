//
//  CityCell.swift
//  Lesson17
//
//  Created by Алексей Алексеев on 02.06.2021.
//

import UIKit

final class CityCell: UITableViewCell {

    static var reuseID: String {
        self.description()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(weather: Weather) {
        nameLabel.text = weather.name
        descriptionLabel.text = weather.description
    }
    
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            nameLabel.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: -16),
            
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
        ])
    }
    
}
