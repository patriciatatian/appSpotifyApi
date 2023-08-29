import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var artistaGenero: UILabel!
    @IBOutlet weak var artistaSeguidores: UILabel!
    @IBOutlet weak var artistaNome: UILabel!
    @IBOutlet weak var artistaPopularidade: UILabel!
    @IBOutlet weak var artistaImageView: UIImageView!
    @IBOutlet weak var artistaTitulo: UILabel!

    @IBOutlet weak var botao: UIButton!
    var artista: Artista!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        artistaImageView.layer.cornerRadius = 8
        artistaImageView.layer.masksToBounds = true
        artistaImageView.contentMode = .scaleAspectFill
        artistaImageView.backgroundColor = .blue
        
        artistaTitulo.text = artista.name
        configure(with: artista)
        botao.addTarget(self, action: #selector(abrirURL), for: .touchUpInside) //quando o botão for pressionado e liberado, a função abrirURL dentro da classe                                                                        DetailViewController será chamada, permitindo que abra uma URL externa                                                                          relacionada ao artista.
    
    }
    @objc func abrirURL() { // Função para abrir o URL quando o botão é pressionado
            if let url = URL(string: artista.externalUrls.spotify) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil) //solicita ao sistema iOS para abrir a URL mostrando a página correspondente no navegador da web.
            }
        }
    func configure(with artista: Artista){
        artistaNome.text = "Nome: \(artista.name)"
        artistaGenero.text = "Gênero Musical: \(artista.genres[0])"
        artistaTitulo.text = artista.name
        artistaSeguidores.text = "Número de Seguidores: \(artista.followers.total)"
        artistaPopularidade.text = "Popularidade: \(artista.popularity)"
        artistaImageView.download(from: artista.images[0].url)
        
    }
}
