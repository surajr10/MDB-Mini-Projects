//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//
import Foundation
import UIKit

class PokedexVC: UIViewController, UIScrollViewDelegate, CollectionViewCellDelegate, UISearchBarDelegate {
    
    var searchBar: UISearchBar!
    var searchBarActive: Bool = false
    var dataSource: [Pokemon] = []
    var dataSourceForSearchResult: [Pokemon]?
    
    func showAlert(pokeTag: Int) {
        let vc = PokemonProfileVC(pokeTag: pokeTag)
        present(vc, animated: true, completion: nil)
    }
    
    
    let pokemons = PokemonGenerator.shared.getPokemonArray()
    var passPokemon: Pokemon?

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokeCell.self, forCellWithReuseIdentifier: PokeCell.reuseIdentifier)
        
        return collectionView
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        for pokemon in pokemons {
            dataSource.append(pokemon)
        }
        dataSourceForSearchResult = [Pokemon]()
        
        searchBar = UISearchBar()
        let searchBarSTF = searchBar.sizeThatFits(CGSize.init(width: view.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        searchBar.frame = CGRect(x: view.bounds.width*0.1, y: view.safeAreaInsets.top + 20, width: view.bounds.width*0.8, height: 50)
        searchBar.delegate = self
        searchBar.placeholder = "Search Pokemon"
//        searchBar.backgroundColor = .white
//        searchBar.tintColor = .white
        searchBar.isHidden = false
        searchBar.isTranslucent = false
        searchBar.barStyle = .default
        
        
        view.addSubview(searchBar)
        
        self.collectionView.addSubview(searchBar)
        
        scrollView.delegate = self
        scrollView.frame = view.bounds
        scrollView.isScrollEnabled = true
        scrollView.contentSize = view.frame.size
        
        view.addSubview(scrollView)
//        scrollView.addSubview(collectionView)
        
        collectionView.frame = view.bounds
//        collectionView.backgroundColor = .systemGroupedBackground
//        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PokeCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PokeCell.reuseIdentifier)
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.bottomAnchor.length + 100, right: 0)
        
        var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.minimumLineSpacing = 50
//        layout.minimumInteritemSpacing = 50
        layout.sectionInset = UIEdgeInsets(top: 100, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing = 40
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width-90) / 2, height: 200)
        
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.viewDidLoad()
        print("scrub")
//        self.collectionView.collectionViewLayout.invalidateLayout()
//
//        self.collectionView.reloadData()
    }
    
    func searchBar(_searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            self.searchBarActive = true
            self.filterContentForSearchText(searchText: searchText)
            self.collectionView.reloadData()
        } else {
            self.searchBarActive = false
            self.collectionView.reloadData()
        }
        
        
    }
    
    func filterContentForSearchText(searchText: String) {
        self.dataSourceForSearchResult = self.dataSource.filter({ (pokemon) -> Bool in
            let pokemonName = pokemon.name
            return pokemonName.contains(searchText)
            
            
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
//        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = true
        DispatchQueue.main.async{
            self.collectionView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = false
        DispatchQueue.main.async{
            self.collectionView.reloadData()
        }
    }
    
    
//    @objc func didTapPokemon(_ sender: UIButton) {
//
//        let pokeTag = sender.tag
//        let vc = PokemonProfileVC(pokeTag: pokeTag)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
//
//    }
}

extension PokedexVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchBarActive {
            return self.dataSourceForSearchResult!.count
        }
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCell.reuseIdentifier, for: indexPath) as! PokeCell
        if self.searchBarActive {
            cell.pokeUrl = dataSourceForSearchResult![indexPath.item].imageUrlLarge
            cell.pokeName = dataSourceForSearchResult![indexPath.item].name
            cell.pokeID = dataSourceForSearchResult![indexPath.item].id
            cell.delegate = self
            cell.pokeTag = indexPath.item
        } else {
            cell.pokeUrl = dataSource[indexPath.item].imageUrlLarge
            cell.pokeName = dataSource[indexPath.item].name
            cell.pokeID = dataSource[indexPath.item].id
            cell.delegate = self
            cell.pokeTag = indexPath.item
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 40)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let cell = co
//    }

    func collectionView(_collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        passPokemon = pokemons[indexPath.item]
        performSegue(withIdentifier: "Pokemon Profile VC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Pokemon Profile VC" {
            let vc = segue.destination as? PokemonProfileVC
            vc?.currPokemon = passPokemon!
        }
    }

}

//protocol PokeCellDelegate {
//    func buttonPressedAtIndexPath(inCell: PokeCell)
//}

protocol CollectionViewCellDelegate: class {
    func showAlert(pokeTag: Int)
}

class PokeCell: UICollectionViewCell {
    static let reuseIdentifier = "pokeCell"
//    var delegate: PokeCellDelegate?
    weak var delegate: CollectionViewCellDelegate?
    
    var pokeTag: Int? {
        didSet {
            guard let pokeTag = pokeTag else {return}
            pokeButton.tag = pokeTag
        }
    }
    
    var pokeUrl: String? {
        didSet {
            
            guard let pokeUrl = pokeUrl else {return}
            let Url: URL = URL(string: pokeUrl)!
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData: NSData = NSData(contentsOf: Url)!
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    self.imageView.image = image
                    self.pokeButton.setImage(image, for: .normal)
                }
            }
            
            
//            guard let pokemonURL = URL(string: pokeUrl) else {return}
            
            
            
//            let image = UIImage(systemName: pokeUrl)
//            let image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]]
//            imageView.image = image
        }
    }
    
    var pokeName: String? {
        didSet {
            guard let pokeName = pokeName else {return}
            nameView.text = pokeName
            pokeButton.accessibilityLabel = pokeName
            
        }
    }
    
    var pokeID: Int? {
        didSet {
            guard let pokeID = pokeID else {return}
            idView.text = String(pokeID)
        }
    }
    
    private let pokeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = .black
        button.titleEdgeInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let idView: UILabel = {
        let id = UILabel()
        id.translatesAutoresizingMaskIntoConstraints = false
        id.textAlignment = .center
        id.textColor = .black
        return id
    }()
    
    private let nameView: UILabel = {
        let nv = UILabel()
        nv.translatesAutoresizingMaskIntoConstraints = false
        nv.textAlignment = .center
        nv.textColor = .black
        return nv
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pokeButton.addSubview(nameView)
        pokeButton.addSubview(idView)
        contentView.backgroundColor = .white
//        contentView.backgroundColor = .white
//        contentView.addSubview(imageView)
//        contentView.addSubview(idView)
//        contentView.addSubview(nameView)
        contentView.addSubview(nameView)
        contentView.addSubview(pokeButton)
        contentView.addSubview(idView)
//        nameView.frame = contentView.bounds
//        imageView.frame = contentView.bounds
//        idView.frame = contentView.bounds
//        imageView.frame = contentView.bounds
        
        
        pokeButton.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        nameView.frame = CGRect(x: 0, y: 150, width: 150, height: 25)
        idView.frame = CGRect(x:0, y: 175, width: 150, height: 25)
        
        
        pokeButton.addTarget(self, action: #selector(didTapPokemon(_:)), for: .touchUpInside)
//        imageView.frame = CGRect(x: 0, y: 50, width: 150, height: 150)
//        idView.frame = CGRect(x: 0, y: 250, width: 200, height: 50)
        
        
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: contentView.centerYAnchor),
//            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
//        NSLayoutConstraint.activate([
//            idView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            idView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    
    
    @objc func didTapPokemon(_ sender: UIButton) {

//        delegate?.showAlert(pokeTag: sender.tag)
        let vc = PokemonProfileVC(pokeTag: sender.tag)
        print(String(sender.tag))
        self.window!.rootViewController!.present(vc, animated: true, completion: nil)

        
//        let pokeTag = sender.tag
//        let vc = PokemonProfileVC(pokeTag: pokeTag)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)

    }
    

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


extension String {
    func index(of string: String) -> String.Index? {
        return range(of: string)?.lowerBound
    }
}
