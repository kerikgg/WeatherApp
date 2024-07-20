//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by kerik on 16.07.2024.
//

import Foundation
import UIKit

final class WeatherViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var viewModel: WeatherViewModel
    private var dataSource: WeatherCollectionViewDataSource

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        self.dataSource = WeatherCollectionViewDataSource(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.reuseIdentifier)

        return collectionView
    }()

    private lazy var animationView: UIView = {
        let animationView = UIView()
        animationView.backgroundColor = .lightGray
        animationView.translatesAutoresizingMaskIntoConstraints = false

        return animationView
    }()

    private var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupAnimationView()
        view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let weatherModel = viewModel.getRandomWeather() else { return }
        displayWeatherAnimation(for: weatherModel)
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setupAnimationView() {
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == selectedIndexPath {
            return
        }

        if let selectedIndexPath = selectedIndexPath {
            collectionView.deselectItem(at: selectedIndexPath, animated: true)
        }

        selectedIndexPath = indexPath

        let selectedWeather = viewModel.getWeatherConditions()[indexPath.row]
        displayWeatherAnimation(for: selectedWeather)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 80)
    }

    private func displayWeatherAnimation(for condition: WeatherModel) {
        removeExistingAnimationsWithTransition {
            condition.animationSetup(self.animationView)

            let animationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.animationView.bounds.width, height: 50))
            animationLabel.text = condition.description
            animationLabel.textAlignment = .center
            animationLabel.font = UIFont.systemFont(ofSize: 20)
            animationLabel.center = CGPoint(x: self.animationView.bounds.midX, y: self.animationView.bounds.maxY - 60)
            self.animationView.addSubview(animationLabel)
        }
    }

    private func removeExistingAnimationsWithTransition(completion: @escaping () -> Void) {
        // Анимация исчезновения старых анимаций
        UIView.animate(withDuration: 0.5, animations: {
            for subview in self.animationView.subviews {
                subview.alpha = 0
            }
            self.animationView.layer.sublayers?.forEach { layer in
                layer.opacity = 0
            }
        }, completion: { _ in

            self.animationView.subviews.forEach { $0.removeFromSuperview() }
            self.animationView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

            completion()

            UIView.animate(withDuration: 0.5, animations: {
                for subview in self.animationView.subviews {
                    subview.alpha = 1
                }
                self.animationView.layer.sublayers?.forEach { layer in
                    layer.opacity = 1
                }
            })
        })
    }
}
