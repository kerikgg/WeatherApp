//
//  WeatherCollectionViewDataSource.swift
//  WeatherApp
//
//  Created by kerik on 18.07.2024.
//

import UIKit

final class WeatherCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private let viewModel: WeatherViewModel

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getWeatherConditions().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.reuseIdentifier, for: indexPath) as! WeatherCollectionViewCell
        let showSeparator = indexPath.row < viewModel.getWeatherConditions().count - 1
        cell.configure(with: viewModel.getWeatherConditions()[indexPath.row], showSeparator: showSeparator)
        return cell
    }
}
