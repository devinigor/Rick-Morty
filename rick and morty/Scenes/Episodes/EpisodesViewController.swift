//
//  EpisodesViewController.swift
//  rick and morty
//
//  Created by Игорь Девин on 29.11.2023.
//

import UIKit

final class EpisodesViewController: UIViewController {

    private let layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    private var results = [Result]()
    private var character = String()
    private var randomEpisodeName = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupCollectionView()
        loadData()
    }

    private func setupCollectionView() {
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 24, bottom: 0, right: 24)
        layout.minimumLineSpacing = 55

        collectionView.register(EpisodesCollectionViewCell.self, forCellWithReuseIdentifier: EpisodesCollectionViewCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = false

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func loadData() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode") else { return }
        let urlSession = URLSession.shared

        urlSession.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            do {
                let jsonData = try JSONDecoder().decode(Welcome.self, from: data)

                self.results = jsonData.results

                self.fetchCharacterImage(from: jsonData.results.randomElement()?.characters.randomElement() ?? "")
                self.randomEpisodeName = "\(jsonData.results.randomElement()?.name ?? "") | \(jsonData.results.randomElement()?.episode ?? "")"
            } catch {
                print("Error")
            }
        }.resume()
    }

    func fetchCharacterImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                let jsonCharacter = try JSONDecoder().decode(Character.self, from: data)

                DispatchQueue.main.async {
                    self.character = jsonCharacter.image
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error")
            }
        }

        task.resume()
    }
}

extension EpisodesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodesCollectionViewCell.identifier, for: indexPath) as? EpisodesCollectionViewCell else {
            fatalError("Unable to dequeue CustomCollectionViewCell")
        }

        let result = results[indexPath.row]
        cell.configureCell(result: result, character: character, randomEpisodeName: randomEpisodeName)

        return cell
    }
}

extension EpisodesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layoutInsets = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let insets = layoutInsets?.sectionInset ?? UIEdgeInsets.zero
        let width = collectionView.bounds.width - (insets.left + insets.right)
        return CGSize(width: width, height: width)
    }
}


extension EpisodesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = DetailedInformationViewController()
        let id = results[indexPath.row].id

        viewController.configure(id: id, character: character)

        navigationController?.pushViewController(viewController, animated: true)
    }
}
