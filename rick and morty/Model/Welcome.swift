//
//  Welcome.swift
//  rick and morty
//
//  Created by Игорь Девин on 29.11.2023.
//

import Foundation

struct Welcome: Decodable {
    let results: [Result]
}

struct Result: Decodable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}
