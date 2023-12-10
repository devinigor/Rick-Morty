//
//  DetailedInformationTableViewCell.swift
//  rick and morty
//
//  Created by Игорь Девин on 07.12.2023.
//

import UIKit

final class DetailedInformationTableViewCell: UITableViewCell {
    private let topLabel = UILabel()
    private let bottomLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        topLabel.font = UIFont.systemFont(ofSize: 16)
        topLabel.textColor = .black

        bottomLabel.font = UIFont.systemFont(ofSize: 14)
        bottomLabel.textColor = .gray

        topLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(bottomLabel)
        contentView.addSubview(topLabel)

        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            topLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            topLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 5),
            bottomLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bottomLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bottomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(topText: String, bottomText: String) {
        topLabel.text = topText

        if bottomLabel.text != String() {
            bottomLabel.text = bottomText
        } else {
            bottomLabel.text = "Unknown"
        }
    }
}

