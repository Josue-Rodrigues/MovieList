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
    @IBOutlet weak var generoDetalheFilme: UILabel!
    
    @IBOutlet weak var Favoritar: UIButton!

    @IBAction func botaoDescricao(_ sender: Any) {
        alertaDescricao()
    }
    
    var recoveredMovie:SelectedMovie = SelectedMovie()
    var movies:[ListaFilme] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Favoritar.setImage(UIImage(named: "coracaopreto"), for: .normal)
        
        recoverMovieList()
        recoverMovieDetails()
    }
    
    func recoverMovieList() {
        
        if let url = URL(string: "https://api.themoviedb.org/3/movie/550/similar?api_key=3762450a6d6933a5ce25ea49eca99ce1") {
            let tarefa = URLSession.shared.dataTask(with: url) { (data, request, error) in
                
                if error == nil {
                    
                    if let dataApi = data {
                        
                        do {
                            
                            let listMovie:ListaFilmeResponse = try JSONDecoder().decode(ListaFilmeResponse.self, from: dataApi)
                            
                            DispatchQueue.main.async(execute: {
                                
                                self.movies = listMovie.results
                                self.TableView.reloadData()

                            })
                            
                        } catch {
                            print("Erro ao formatar JSON")
                        }
                    }
                    
                }else{
                    
                    let alert = Alert(title: "ATENÇÃO!!", message: "Erro ao recuperar os dados de detalhes do filme", button: "Confirmar")
                    self.present(alert.getAlert(), animated: true, completion: nil)
                }
            }
            
            tarefa.resume()
        }
    }
    
    func recoverMovieDetails(idImage:String = "19898") {
        
        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(idImage)?api_key=3762450a6d6933a5ce25ea49eca99ce1") {
            let tarefa = URLSession.shared.dataTask(with: url) { (data, request, error) in
                if error == nil {
                    if let dataApi = data {
                        
                        do {
                            
                            let detailsMovie:DetalhesFilmeResponse = try JSONDecoder().decode(DetalhesFilmeResponse.self, from: dataApi)
                            
                            if let url = NSURL(string: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/\(detailsMovie.poster_path)") {
                                
                                if let dataImage = NSData(contentsOf: url as URL) {
                                    
                                    DispatchQueue.main.async(execute: {
                                        
                                        self.tituloDetalheFilme.text = String(detailsMovie.title)
                                        self.likeDetalheFilme.text = String(detailsMovie.vote_count)
                                        self.viewDetalheFilme.text = String(detailsMovie.popularity)
                                        self.generoDetalheFilme.text = String(detailsMovie.genres[0].name)
                                        self.imagemDetalheFilme.image = UIImage(data: dataImage as Data)
                                        
                                        self.recoveredMovie.description = String(detailsMovie.overview)
                                        self.recoveredMovie.title = String(detailsMovie.title)
                                        
                                    })
                                }
                            }
                            
                        } catch {
                            let alert = Alert(title: "ATENÇÃO!!", message: "Este filme infelizmente saiu de nossa lista. Deseja tentar novamente", button: "Confirmar")
                            
                            self.present(alert.getAlert(), animated: true, completion: nil)
                        }
                    }
                    
                }else{
                    
                    let alert = Alert(title: "ATENÇÃO!!", message: "Erro ao recuperar os dados de detalhes do filme", button: "Confirmar")
                    self.present(alert.getAlert(), animated: true, completion: nil)
                }
            }
            
            tarefa.resume()
        }
    }
    
    func alertaDescricao() {
        
        let alert = Alert(title: recoveredMovie.title, message: recoveredMovie.description, button: "Exit")
        self.present(alert.getAlert(), animated: true, completion: nil)
    }
}
    
extension ViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = movies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath) as! FilmeCelula
        
        if let url = NSURL(string: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/\(movie.poster_path)") {
            if let data = NSData(contentsOf: url as URL) {
                
                cell.imagemFilme.image = UIImage(data: data as Data)!
                cell.tituloFilme.text = movie.title
                cell.descricaoFilme.text = movie.release_date

            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMovie = self.movies[indexPath.row]
        
        recoverMovieDetails(idImage: String(selectedMovie.id))
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    @IBAction func botaoFavorito(_ sender: Any) {
        
        recoveredMovie.favorite = !recoveredMovie.favorite
        
        if recoveredMovie.favorite {
            Favoritar.setImage(UIImage(named: "coracaobranco"), for: .normal)
            
        } else {
            Favoritar.setImage(UIImage(named: "coracaopreto"), for: .normal)
        }
    }
}

