//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by kerik on 18.07.2024.
//

import UIKit

final class WeatherViewModel {
    private var weatherConditions: [WeatherModel]

    init() {
        weatherConditions = [
            WeatherModel(icon: SystemImages.sun!, description: String(localized: "Clear Sky"), weatherType: .sunny, animationSetup: { view in
                WeatherViewModel.addSunAnimation(to: view)
            }),
            WeatherModel(icon: SystemImages.rain!, description: String(localized: "Light Rain"), weatherType: .rainy, animationSetup: { view in
                WeatherViewModel.addRainAnimation(to: view)
            }),
            WeatherModel(icon: SystemImages.storm!, description: String(localized: "Thunderstorm"), weatherType: .stormy, animationSetup: { view in
                WeatherViewModel.addStormAnimation(to: view)
            }),
            WeatherModel(icon: SystemImages.fog!, description: String(localized: "Dense Fog"), weatherType: .foggy, animationSetup: { view in
                WeatherViewModel.addFogAnimation(to: view)
            })
        ]
    }

    func getWeatherConditions() -> [WeatherModel] {
        return weatherConditions
    }

    func getRandomWeather() -> WeatherModel? {
        return weatherConditions.randomElement()
    }

    static func addSunAnimation(to view: UIView) {
        let sunImageView = UIImageView(image: UIImage(systemName: "sun.max.fill"))
        sunImageView.tintColor = .yellow
        sunImageView.frame = CGRect(x: view.bounds.midX - 50, y: view.bounds.midY - 50, width: 100, height: 100)
        view.addSubview(sunImageView)

        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 10
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        sunImageView.layer.add(rotation, forKey: "rotationAnimation")
    }

    static func addRainAnimation(to view: UIView) {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .line
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: 0)
        emitterLayer.emitterSize = CGSize(width: view.bounds.size.width, height: 1)

        let rainCell = CAEmitterCell()
        rainCell.birthRate = 25
        rainCell.lifetime = 5.0
        rainCell.velocity = 500
        rainCell.velocityRange = 150
        rainCell.emissionLongitude = .pi
        rainCell.scale = 0.2
        rainCell.scaleRange = 0.1
        rainCell.contents = SystemImages.drop?.cgImage

        emitterLayer.emitterCells = [rainCell]
        view.layer.addSublayer(emitterLayer)
    }

    static func addFogAnimation(to view: UIView) {
        func createFogImageView(alpha: CGFloat, duration: Double, yOffset: CGFloat) -> UIImageView {
            let fogImageView = UIImageView(image: SystemImages.smoke)
            fogImageView.tintColor = .white
            fogImageView.frame = CGRect(x: -view.bounds.width, y: yOffset, width: view.bounds.width * 2, height: view.bounds.height)
            fogImageView.alpha = alpha
            return fogImageView
        }

        let fogImageView1 = createFogImageView(alpha: 0.4, duration: 60, yOffset: 0)
        let fogImageView2 = createFogImageView(alpha: 0.6, duration: 50, yOffset: 100)
        let fogImageView3 = createFogImageView(alpha: 0.8, duration: 40, yOffset: 200)

        view.addSubview(fogImageView1)
        view.addSubview(fogImageView2)
        view.addSubview(fogImageView3)

        func animateFogImageView(_ imageView: UIImageView, duration: Double) {
            UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: {
                imageView.frame.origin.x = view.bounds.width
            }, completion: { _ in
                imageView.removeFromSuperview()
            })
        }

        animateFogImageView(fogImageView1, duration: 60)
        animateFogImageView(fogImageView2, duration: 50)
        animateFogImageView(fogImageView3, duration: 40)
    }

    static func addStormAnimation(to view: UIView) {
        addRainAnimation(to: view)

        let flashView = UIView(frame: view.bounds)
        flashView.backgroundColor = .white
        flashView.alpha = 0
        view.addSubview(flashView)

        func flash() {
            UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
                flashView.alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, delay: 0.1, options: [], animations: {
                    flashView.alpha = 0
                }, completion: { _ in
                    let delay = Double.random(in: 2...5)
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        flash()
                    }
                })
            })
        }
        flash()
    }
}
