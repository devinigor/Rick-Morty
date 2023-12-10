//
//  DetailedInformationViewController.swift
//  rick and morty
//
//  Created by Игорь Девин on 07.12.2023.
//

import UIKit
import AVFoundation
import Photos

final class DetailedInformationViewController: UIViewController {

    private var currentTask: URLSessionDataTask?

    private let avatarImageView = UIImageView()

    private let editButton = UIButton()

    private let nameLabel = UILabel()

    private let informationsLabel = UILabel()

    private let tableView = UITableView()

    private var datas = [String: String]()
    private var orderedData = [(key: String, value: String)]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let logoImage = UIImage(named: "logo-black")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit

        logoImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        let logoBarButtonItem = UIBarButtonItem(customView: logoImageView)

        navigationItem.rightBarButtonItem = logoBarButtonItem

        avatarImageView.layer.borderWidth = 5
        avatarImageView.layer.borderColor = UIColor(hex: "#FFF2F2F7")?.cgColor
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true

        let imageEditButton = UIImage(named: "Camera")
        editButton.setImage(imageEditButton, for: .normal)
        editButton.addTarget(self, action: #selector(setAvatar), for: .touchUpInside)

        nameLabel.text = "Rick Sanchez"
        nameLabel.font = UIFont.systemFont(ofSize: 32, weight: .regular)

        informationsLabel.text = "Informations"
        informationsLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        informationsLabel.textColor = UIColor(hex: "#8E8E93FF")

        tableView.register(DetailedInformationTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(avatarImageView)
        view.addSubview(editButton)
        view.addSubview(nameLabel)
        view.addSubview(informationsLabel)
        view.addSubview(tableView)

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        informationsLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 124),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            editButton.heightAnchor.constraint(equalToConstant: 32),
            editButton.widthAnchor.constraint(equalToConstant: 32),
            editButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            editButton.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 9),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 47),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            informationsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18),
            informationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            tableView.topAnchor.constraint(equalTo: informationsLabel.bottomAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }

    public func configure(id: Int, character: String) {
        loadImage(from: character)
        loadData(id: id)
    }

    private func loadData(id: Int) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/\(id)") else { return }
        let urlSession = URLSession.shared

        urlSession.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            do {
                let jsonData = try JSONDecoder().decode(Detailed.self, from: data)
                DispatchQueue.main.async {
                    self.orderedData = [
                                ("Gender", jsonData.gender),
                                ("Status", jsonData.status),
                                ("Specie", jsonData.species),
                                ("Origin", jsonData.origin.name),
                                ("Type", jsonData.type),
                                ("Location", jsonData.location.name),
                            ]
                            self.tableView.reloadData()
                }
            } catch {
                print("Error")
            }
        }.resume()
    }


    private func loadImage(from url: String) {
        guard let imageUrlString = URL(string: url) else {
            self.avatarImageView.image = UIImage(named: "defaultPicture")
            return
        }
        currentTask = URLSession.shared.dataTask(with: imageUrlString) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.avatarImageView.image = UIImage(named: "defaultPicture")
                }
                return
            }
            DispatchQueue.main.async {
                self.avatarImageView.image = UIImage(data: data)
            }
        }
        currentTask?.resume()
    }



    @objc private func setAvatar() {
        let actionSheet = UIAlertController(title: nil, message: "Загрузите изображение", preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
            self?.handleCameraAccess()
        }))

        actionSheet.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { [weak self] _ in
            self?.handlePhotoLibraryAccess()
        }))

        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }

    func handleCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.presentCamera()
                }
            }
        case .restricted, .denied:
            self.showSettingsAlert()
        case .authorized:
            self.presentCamera()
        default:
            fatalError("Unknown authorization status")
        }
    }

    func handlePhotoLibraryAccess() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.presentPhotoPicker()
                    }
                }
            }
        case .restricted, .denied:
            self.showSettingsAlert()
        case .authorized:
            self.presentPhotoPicker()
        default:
            fatalError("Unknown authorization status")
        }
    }


    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }

        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
                self.present(imagePicker, animated: true)
        }
    }

    private func presentPhotoPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

    func showSettingsAlert() {
        let alert = UIAlertController(title: "Доступ запрещен", message: "Перейдите в настройки, чтобы изменить разрешения", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Настройки", style: .default, handler: { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension DetailedInformationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            avatarImageView.image = pickedImage
        }
        dismiss(animated: true)
    }
}

extension DetailedInformationViewController: UINavigationControllerDelegate { }

extension DetailedInformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DetailedInformationTableViewCell else { return UITableViewCell() }

        let item = orderedData[indexPath.row]
        cell.configure(topText: item.key, bottomText: item.value)

        return cell
    }
}

extension DetailedInformationViewController: UITableViewDelegate { }
