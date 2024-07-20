//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by kerik on 16.07.2024.
//

import UIKit

final class WeatherCollectionViewCell: UICollectionViewCell {
    private lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var weatherStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherIcon, weatherLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .white
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        return separatorView
    }()

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        contentView.addSubview(weatherStackView)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            weatherStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            weatherStackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),

            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: 1)
        ])
    }

    func configure(with weatherModel: WeatherModel, showSeparator: Bool) {
        switch weatherModel.weatherType {
        case .sunny:
            weatherLabel.text = String(localized: "Sunny")
        case .rainy:
            weatherLabel.text = String(localized: "Rainy")
        case .stormy:
            weatherLabel.text = String(localized: "Stormy")
        case .foggy:
            weatherLabel.text = String(localized: "Foggy")
        }

        weatherIcon.image = weatherModel.icon
        separatorView.isHidden = !showSeparator
    }
}
