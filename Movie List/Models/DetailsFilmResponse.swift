//
//  ResponseDetalhesFilme.swift
//  Movie List
//
//  Created by Josue Herrera Rodrigues on 10/11/21.
//

import UIKit

struct DetailsFilmResponse: Codable {
    
    let overview: String
    let popularity: Double
    let vote_count: Int64
    let poster_path: String
    let release_date: String
    let title: String
    let backdrop_path: String
    let genres: [MovieGenre]
}

struct MovieGenre: Codable {
    
    let id: Int64
    let name: String
}

class SelectedMovie {
    
    var title: String = ""
    var description: String = ""
    var favorite: Bool = false
}
