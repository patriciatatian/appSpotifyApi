
import UIKit
//primeira tela do app
class MusicViewController: UIViewController {
    
    private var artistas: [Artista] = [ ]
    
    
    
    //criando os componentes e setando as propriedades deles
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0 //texto dinâmico, ou sejao quanto de linhas precisar para executar o texto
        label.text = "Artistas Populares"
        return  label
        
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getToken()
        
    }
    
    private func setupView() { //
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        addViewsInHierarchy()
        setupConstraints()
        
        
    }
    
    private func addViewsInHierarchy() { // adcionando as views na hierarquia
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
    }
    private func  setupConstraints(){ //fazendo setup das constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            
        ])
        
    }
    
    private func getToken() {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        let cliendID = "71f6772a31bf481294bc6d62afefbd66"
        let clientSecret = "a3e7b6678f394e428092fb4df9bd1e3c"
        let data : Data = "grant_type=client_credentials&client_id=\(cliendID)&client_secret=\(clientSecret)".data(using: .utf8)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Aconteceu um erro ❌")
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                guard let data = data else {
                    print("O binário enviado está vazio ❌")
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let tokenResponse = try? decoder.decode(TokenResponse.self, from: data) else {
                    print("O processo de decoder falhou ❌ token")
                    return
                }
                
                self.fetchArtist(using: tokenResponse.accessToken)
                

            }
        }.resume()
    }
    
    private func fetchArtist(using token: String) {
        let ids = [
           
            "1McMsnEElThX1knmY4oliG",
            "1sPg5EHuQXTMElpZ4iUgXe",
            "6gEzJZrbm0F4ihvE9iXR9z",
            "7KdmibNmW5J0q5YtGnJqQ8",
            "06HL4z0CvFAxyc27GXpf02",
            "7FNnA9vBm6EKceENgCGRMb",
            "1AL2GKpmRrKXkYIcASuRFa",
            "7dGJo4pcD2V6oG8kP0tJRR",
            "6XyY86QOPPrYVGvF9ch6wz",
            "1PwOU6fFbmaGkK3wkbb8fU",
            "1MzXJ8AaHdidMAnjgcahS4",
            "0hWRVPGWjaXcEvg8l65Tx0",
            "3yY2gUcIsjMr8hjo51PoJ8",
            "3CIIaeZuFYrAD6PRVyuO4U",
            "6qqNVTkY8uBg9cP3Jd7DAH",
            "00FQb4jTyendYWaN8pK0wa",
            "0jOs0wnXCu1bGGP7kh5uIu",
            
            
            
        ]
        
        var url = URL(string: "https://api.spotify.com/v1/artists")!
        url.append(queryItems: [.init(name: "ids", value: ids.joined(separator: ","))])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Aconteceu um erro ❌")
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                guard let data = data else {
                    print("O binário enviado está vazio ❌")
                    return
                }
                print(String(data: data, encoding: .utf8))
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let spotifyResponse = try? decoder.decode(SpotifyResponse.self, from: data) else {
                    print("O processo de decoder falhou ❌ artista")
                    return
                }
                
                self.artistas = spotifyResponse.artists
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }.resume()
    }
}

  /*private func fetchRemotePopularArtistas(){
        //URL SESSION
        //let artistIDs = ["2CIMQHirSU0MQqyYHq0eOx", "57dN52uHvrHOxijzpIgu3E", "CWHaC5f2uS3yhpwWbIA6"]
        let url = URL(string:"https://api.spotify.com/v1/artists?ids=2CIMQHirSU0MQqyYHq0eOx%2C57dN52uHvrHOxijzpIgu3E%2C1vCWHaC5f2uS3yhpwWbIA6")!
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with:request) { data, _, error in
            if error != nil {return}
            
            guard let data else {return}
            print(String(data: data, encoding: .utf8))
            
        }.resume()
    }
}*/
 
extension MusicViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        artistas.count
    } // retorna a quantidade de linhas da tabela
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ArtistaCell()
        let artista = artistas[indexPath.row]
        cell.setup(artista: artista)
        return cell
    }//retornar qual a celula que eu quero que apareça na célula
}
extension MusicViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //diz qual a seção e linha que o elemento foi tocado
        
        let artista = artistas[indexPath.row]
        let storyboard = UIStoryboard(name: "Detail", bundle: Bundle(for: DetailViewController.self))
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        detailViewController.artista = artista
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
