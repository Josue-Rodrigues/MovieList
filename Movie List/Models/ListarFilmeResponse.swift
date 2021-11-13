//
//  ListarFilmeResponse.swift
//  Movie List
//
//  Created by Josue Herrera Rodrigues on 10/11/21.
//

import UIKit


struct ListaFilmeResponse: Codable {
    let results: [ListaFilme]
}

struct ListaFilme: Codable {
    
    let title: String
    let release_date: String
    let poster_path: String
    let id: Int64
}

