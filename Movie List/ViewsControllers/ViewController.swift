//
//  ViewController.swift
//  Movie List
//
//  Created by Josue Herrera Rodrigues on 09/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var imageDetailMovie: UIImageView!
    @IBOutlet weak var titleDetailMovie: UILabel!
    @IBOutlet weak var likeDetailMovie: UILabel!
    @IBOutlet weak var viewDetailMovie: UILabel!
    @IBOutlet weak var genreDetailMovie: UILabel!
    @IBOutlet weak var favorite: UIButton!
    
    @IBAction func favoriteButton(_ sender: Any) {
        
        recoveredMovie.favorite = !recoveredMovie.favorite
        
        if recoveredMovie.favorite {
            favorite.setImage(UIImage(named: "coracaobranco"), for: .normal)
            
        } else {
            favorite.setImage(UIImage(named: "coracaopreto"), for: .normal)
        }
    }
    
    @IBAction func buttonDescription(_ sender: Any) {
        
        alertDescription()
    }
    
    var recoveredMovie:SelectedMovie = SelectedMovie()
    var movies:[MovieList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favorite.setImage(UIImage(named: "coracaopreto"), for: .normal)
        
        recoverMovieList()
        recoverMovieDetails()
    }
    
    func recoverMovieList() {
        
        if let url = URL(string: "https://api.themoviedb.org/3/movie/550/similar?api_key=3762450a6d6933a5ce25ea49eca99ce1") {
            let task = URLSession.shared.dataTask(with: url) { (data, request, error) in
                if error == nil {
                    if let dataApi = data {
                        
                        do {
                            
                            let listMovie:MovieListResponse = try JSONDecoder().decode(MovieListResponse.self, from: dataApi)
                            
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
            
            task.resume()
        }
    }
    
    func recoverMovieDetails(idImage:String = "479226") {
        
        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(idImage)?api_key=3762450a6d6933a5ce25ea49eca99ce1") {
            let task = URLSession.shared.dataTask(with: url) { (data, request, error) in
                if error == nil {
                    if let dataApi = data {
                        
                        do {
                            
                            let detailsMovie:DetailsFilmResponse = try JSONDecoder().decode(DetailsFilmResponse.self, from: dataApi)
                            
                            if let url = NSURL(string: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/\(detailsMovie.poster_path)") {
                                
                                if let dataImage = NSData(contentsOf: url as URL) {
                                    
                                    DispatchQueue.main.async(execute: {
                                        
                                        self.titleDetailMovie.text = String(detailsMovie.title)
                                        self.likeDetailMovie.text = String(detailsMovie.vote_count)
                                        self.viewDetailMovie.text = String(detailsMovie.popularity)
                                        self.genreDetailMovie.text = String(detailsMovie.genres[0].name)
                                        self.imageDetailMovie.image = UIImage(data: dataImage as Data)
                                        
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
            
            task.resume()
        }
    }
    
    func alertDescription() {
        
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
                
                cell.imageMovieList.image = UIImage(data: data as Data)!
                cell.titleMovieList.text = movie.title
                cell.dateMovieList.text = movie.release_date
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMovie = self.movies[indexPath.row]
        
        recoverMovieDetails(idImage: String(selectedMovie.id))
        
        print(selectedMovie.id)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

