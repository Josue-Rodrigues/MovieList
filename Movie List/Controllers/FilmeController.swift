//
//  FilmeServico.swift
//  Movie List
//
//  Created by Josue Herrera Rodrigues on 10/11/21.
//

import UIKit

class FilmeServico {
    
    func recuperarDetalhesFilme() -> Void {

        if let url = URL(string: "https://api.themoviedb.org/3/movie/50348?api_key=3762450a6d6933a5ce25ea49eca99ce1") {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                
                if erro == nil {
                    
                    if let dados = dados {
                        
                        do {
                            
                            let resposta = try JSONDecoder().decode(ResponseDetalhesFilme.self, from: dados)
                            
                        } catch {
                            print("Erro ao formatar retorno")
                        }
                    }
                    
                }else{
                    print("Erro ao fazer a consulta do preço")
                }
            }

            tarefa.resume()
        }
    }
}


