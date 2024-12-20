//
//  APICastResponse.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

struct APICastResponse: Decodable {
    let cast: [APICastMember]
    let crew: [APICastMember]
}

struct APICastMember: Decodable {
    let id: Int
    let name: String
    let popularity: Double
    let department: String?

    enum CodingKeys: String, CodingKey {
        case id, name, popularity, department
    }
}
