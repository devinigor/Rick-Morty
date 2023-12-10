//
//  LaunchScreenViewController.swift
//  rick and morty
//
//  Created by Игорь Девин on 10.11.2023.
//

import UIKit

final class LaunchScreenViewController: UIViewController {
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSelfView()
    }

    private func startTimer() {
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(goToEpisodesViewController), userInfo: nil, repeats: false)
    }

    private func setupSelfView() {
        startRotatingImage()

        setupImageView()
        startTimer()
    }

    private func setupImageView() {
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        imageView.image = UIImage(named: "rick-and-morty-31013.png")
    }

   private func startRotatingImage() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 3
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        imageView.layer.add(rotation, forKey: "rotationAnimation")
    }

    private func stopRotatingImage() {
        imageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    @objc private func goToEpisodesViewController() {
        stopRotatingImage()

        let viewController = TabBarViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
