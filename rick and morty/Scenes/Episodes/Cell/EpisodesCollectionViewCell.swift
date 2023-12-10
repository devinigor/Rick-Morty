//
//  EpisodesCollectionViewCell.swift
//  rick and morty
//
//  Created by Игорь Девин on 29.11.2023.
//

import UIKit

final class EpisodesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EpisodesCollectionViewCell"

    private var currentTask: URLSessionDataTask?

    private let imageView = UIImageView()

    private let seriesContenerView = UIView()

    private let nameLabel = UILabel()
    private let nameLabelContenerView = UIView()

    private let pilotContenerView = UIView()
    private let seriesImageView = UIImageView()
    private let seriesNameLabel = UILabel()
    private let favoriteImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()

        imageView.image = UIImage(named: "defaultPicture")
        imageView.contentMode = .scaleAspectFill

        pilotContenerView.backgroundColor = UIColor(hex: "#FFF9F9F9")
        pilotContenerView.layer.cornerRadius = 16

        nameLabel.text = "Rick Sanchez"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        nameLabel.textAlignment = .left
        nameLabel.backgroundColor = .white

        seriesContenerView.backgroundColor = .white

        nameLabelContenerView.backgroundColor = .white

        seriesImageView.image = UIImage(named: "Play")

        favoriteImageView.image = UIImage(named: "AddFavorite")

        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        backgroundColor = .clear

        contentView.addSubview(imageView)
        contentView.addSubview(seriesContenerView)

        seriesContenerView.addSubview(nameLabelContenerView)
        seriesContenerView.addSubview(seriesImageView)
        seriesContenerView.addSubview(pilotContenerView)

        pilotContenerView.addSubview(seriesImageView)
        pilotContenerView.addSubview(seriesNameLabel)
        pilotContenerView.addSubview(favoriteImageView)

        nameLabelContenerView.addSubview(nameLabel)


        imageView.translatesAutoresizingMaskIntoConstraints = false
        seriesContenerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabelContenerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        seriesImageView.translatesAutoresizingMaskIntoConstraints = false
        pilotContenerView.translatesAutoresizingMaskIntoConstraints = false
        seriesNameLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            seriesContenerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seriesContenerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seriesContenerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seriesContenerView.heightAnchor.constraint(equalToConstant: 125),

            nameLabelContenerView.leadingAnchor.constraint(equalTo: seriesContenerView.leadingAnchor),
            nameLabelContenerView.trailingAnchor.constraint(equalTo: seriesContenerView.trailingAnchor),
            nameLabelContenerView.topAnchor.constraint(equalTo: seriesContenerView.topAnchor),
            nameLabelContenerView.heightAnchor.constraint(equalToConstant: 54),

            nameLabel.leadingAnchor.constraint(equalTo: nameLabelContenerView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: nameLabelContenerView.topAnchor, constant: 12),

            pilotContenerView.topAnchor.constraint(equalTo: nameLabelContenerView.bottomAnchor),
            pilotContenerView.bottomAnchor.constraint(equalTo: seriesContenerView.bottomAnchor),
            pilotContenerView.leadingAnchor.constraint(equalTo: seriesContenerView.leadingAnchor),
            pilotContenerView.trailingAnchor.constraint(equalTo: seriesContenerView.trailingAnchor),

            seriesImageView.widthAnchor.constraint(equalToConstant: 33),
            seriesImageView.heightAnchor.constraint(equalToConstant: 33),
            seriesImageView.leadingAnchor.constraint(equalTo: pilotContenerView.leadingAnchor, constant: 22),
            seriesImageView.topAnchor.constraint(equalTo: pilotContenerView.topAnchor, constant: 22),

            seriesNameLabel.leadingAnchor.constraint(equalTo: seriesImageView.trailingAnchor, constant: 10),
            seriesNameLabel.trailingAnchor.constraint(equalTo: favoriteImageView.leadingAnchor, constant: 10),
            seriesNameLabel.centerYAnchor.constraint(equalTo: seriesImageView.centerYAnchor),

            favoriteImageView.trailingAnchor.constraint(equalTo: pilotContenerView.trailingAnchor, constant: -18),
            favoriteImageView.centerYAnchor.constraint(equalTo: seriesImageView.centerYAnchor),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 40),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        currentTask?.cancel()
        imageView.image = nil
    }

    public func configureCell(result: Result, character: String, randomEpisodeName: String) {
        seriesNameLabel.text = randomEpisodeName
        loadImage(from: character)
    }

    private func loadImage(from url: String) {
        guard let imageUrlString = URL(string: url) else {
            self.imageView.image = UIImage(named: "defaultPicture")
            return
        }
        currentTask = URLSession.shared.dataTask(with: imageUrlString) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "defaultPicture")
                }
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
        currentTask?.resume()
    }

    private func setupCell() {

        backgroundColor = .white

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
    }
}
