//
//  ViewController.swift
//  Movie List
//
//  Created by Josue Herrera Rodrigues on 09/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var tituloDetalheFilme: UILabel!
    @IBOutlet weak var likeDetalheFilme: UILabel!
    @IBOutlet weak var viewDetalheFilme: UILabel!
    @IBOutlet weak var imagemDetalheFilme: UIImageView!
    
    @IBOutlet weak var Favoritar: UIButton!

    @IBAction func botaoDescricao(_ sender: Any) {
        alertaDescricao()
    }
    
    var filmeRecuperado:FilmeSelecionado = FilmeSelecionado()
    var filmes:[ListaFilme] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Favoritar.setImage(UIImage(named: "coracaopreto"), for: .normal)
        
        recuperarListarFilme()
        recuperarDetalhesFilme()
    }
    
    func recuperarListarFilme() {
        
        if let url = URL(string: "https://api.themoviedb.org/3/movie/550/similar?api_key=3762450a6d6933a5ce25ea49eca99ce1") {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                
                if erro == nil {
                    
                    if let dados = dados {
                        
                        do {
                            
                            let detalhesFilme:ListaFilmeResponse = try JSONDecoder().decode(ListaFilmeResponse.self, from: dados)
                            
                            DispatchQueue.main.async(execute: {
                                
                                self.filmes = detalhesFilme.results
                                self.TableView.reloadData()

                            })
                            
                        } catch {
                            print("Erro ao formatar JSON")
                        }
                    }
                    
                }else{
                    
                    let alerta = Alerta(titulo: "ATENÇÃO!!", mensagem: "Erro ao recuperar os dados de detalhes do filme", botao: "Confirmar")
                    self.present(alerta.getAlerta(), animated: true, completion: nil)
                }
            }
            
            tarefa.resume()
        }
    }
    
    func recuperarDetalhesFilme(idFilme:String = "19898") {
        
        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(idFilme)?api_key=3762450a6d6933a5ce25ea49eca99ce1") {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                if erro == nil {
                    if let dados = dados {
                        
                        do {
                            
                            let detalhesFilme:DetalhesFilmeResponse = try JSONDecoder().decode(DetalhesFilmeResponse.self, from: dados)
                            
                            if let url = NSURL(string: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/\(detalhesFilme.poster_path)") {
                                if let data = NSData(contentsOf: url as URL) {
                                    
                                    DispatchQueue.main.async(execute: {
                                        
                                        self.tituloDetalheFilme.text = String(detalhesFilme.title)
                                        self.likeDetalheFilme.text = String(detalhesFilme.vote_count)
                                        self.viewDetalheFilme.text = String(detalhesFilme.popularity)
                                        self.imagemDetalheFilme.image = UIImage(data: data as Data)
                                        
                                        self.filmeRecuperado.descricao = String(detalhesFilme.overview)
                                        self.filmeRecuperado.titulo = String(detalhesFilme.title)
                                        
                                    })
                                }
                            }
                            
                        } catch {
                            
                            let alerta = Alerta(titulo: "ATENÇÃO!!", mensagem: "Este filme infelizmente saiu de nossa lista. Deseja tentar novamente", botao: "Confirmar")
                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                        }
                    }
                    
                }else{
                    
                    let alerta = Alerta(titulo: "ATENÇÃO!!", mensagem: "Erro ao recuperar os dados de detalhes do filme", botao: "Confirmar")
                    self.present(alerta.getAlerta(), animated: true, completion: nil)
                }
            }
            
            tarefa.resume()
        }
    }
    
    func alertaDescricao() {
        
        let alerta = Alerta(titulo: filmeRecuperado.titulo, mensagem: filmeRecuperado.descricao, botao: "Exit")
        self.present(alerta.getAlerta(), animated: true, completion: nil)
    }
}
    
extension ViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let filme = filmes[indexPath.row]
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath) as! FilmeCelula
        
        if let url = NSURL(string: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/\(filme.poster_path)") {
            if let data = NSData(contentsOf: url as URL) {
                
                celula.imagemFilme.image = UIImage(data: data as Data)!
                celula.tituloFilme.text = filme.title
                celula.descricaoFilme.text = filme.release_date
            }
        }
        
        return celula
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let filmeSelecionado = self.filmes[indexPath.row]
        
        recuperarDetalhesFilme(idFilme: String(filmeSelecionado.id))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    @IBAction func botaoFavorito(_ sender: Any) {
        
        filmeRecuperado.favorito = !filmeRecuperado.favorito
        
        if filmeRecuperado.favorito {
            Favoritar.setImage(UIImage(named: "coracaobranco"), for: .normal)
            
        } else {
            Favoritar.setImage(UIImage(named: "coracaopreto"), for: .normal)
        }
    }
}

