//
//  Filmes.swift
//  Movie List
//
//  Created by Josue Herrera Rodrigues on 09/11/21.
//

import UIKit

class Filme {
    
    var imagem: UIImage
    var titulo: String
    var descricao: String
    
    init(imagem: UIImage, titulo: String, descricao: String) {
        
        self.imagem = imagem
        self.titulo = titulo
        self.descricao = descricao
    }
}
