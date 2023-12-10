//
//  Detailed.swift
//  rick and morty
//
//  Created by Игорь Девин on 07.12.2023.
//

import Foundation

struct Detailed: Decodable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Location: Decodable {
    let name: String
    let url: String
}
