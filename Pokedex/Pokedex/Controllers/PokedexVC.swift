//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//
import Foundation
import UIKit

class PokedexVC: UIViewController, UIScrollViewDelegate, CollectionViewCellDelegate {
    
    var changeView: Bool = false
    var searchBar: UISearchBar!
    var searchBarActive: Bool = false
    var filteredPokemons: [Pokemon]?
    var selectedType: String = "None"
//    var dataSource: [Pokemon] = []
//    var dataSourceForSearchResult: [Pokemon]?
    let types: [String] = ["All", "Bug", "Grass","Dark","Ground", "Dragon", "Electric", "Normal", "Fairy", "Poison", "Fighting", "Psychic", "Fire", "Rock", "Flying", "Steel","Ghost","Water","Unknown"]

    
    
    
    let toggle: UIButton = {
        let button = UIButton()
        button.setTitle("Toggle", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        return button
    }()
    
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

        filteredPokemons = pokemons
        
//        for pokemon in pokemons {
//            dataSource.append(pokemon)
//        }
//        dataSourceForSearchResult = [Pokemon]()
        
        searchBar = UISearchBar()
        let searchBarSTF = searchBar.sizeThatFits(CGSize.init(width: view.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        searchBar.frame = CGRect(x: view.bounds.width*0.05, y: view.safeAreaInsets.top + 20, width: view.bounds.width*0.6, height: 25)
        self.searchBar.delegate = self
        searchBar.placeholder = "Search Pokemon"

        searchBar.isHidden = false
        searchBar.isTranslucent = false
        searchBar.barStyle = .default
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = types
        
        
        view.addSubview(searchBar)
        collectionView.addSubview(searchBar)
        
        scrollView.delegate = self
        scrollView.frame = view.bounds
        scrollView.isScrollEnabled = true
        scrollView.contentSize = view.frame.size
        
        view.addSubview(scrollView)
        
        collectionView.frame = view.bounds

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PokeCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PokeCell.reuseIdentifier)

        
        var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        layout.sectionInset = UIEdgeInsets(top: 100, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing = 40
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width-90) / 2, height: 200)
        
        view.addSubview(collectionView)
        
        toggle.frame = CGRect(x: view.bounds.width*0.7, y: view.safeAreaInsets.top + 30, width: view.bounds.width*0.25, height: 25)

        collectionView.addSubview(toggle)
        toggle.addTarget(self, action: #selector(didTapToggle(_:)), for: .touchUpInside)
    }
    
    

//        filteredPokemons = pokemons.filter({ pokemon in pokemon.name.contains(searchText)})
//        if filteredPokemons?.count == 0 {
//            filteredPokemons = pokemons
//        }
//        if (currSelectedType != "All") {
//            filteredPokemons = filteredPokemons?.filter({ p in
//                for t in p.types {
//                    if t.rawValue == currSelectedType {
//                        return true
//                    }
//                }
//                return false
//            })
//        }
//
//        collectionView.reloadData()
//    }
    
//    func filterContentForSearchText(searchText: String) {
//        self.dataSourceForSearchResult = self.dataSource.filter({ (pokemon) -> Bool in
////            let pokemonName = pokemon.name
////            print(pokemonName)
////            print(searchText)
////            print(pokemonName.contains(searchText))
////            return pokemonName.contains(searchText)
//            let pokemonNameString: NSString = pokemon.name as NSString
//            return (pokemonNameString.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
//
//        })
//
//
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
////        self.searchBarActive = true
////        self.view.endEditing(true)
//
////        if !self.searchBarActive {
////            self.searchBarActive = true
////            DispatchQueue.main.async{
////                self.collectionView.reloadData()
////            }
////        }
//        collectionView.reloadData()
////        searchBar.resignFirstResponder()
////        searchBar.resignFirstResponder()
//    }
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.searchBarActive = true
//        DispatchQueue.main.async{
//            self.collectionView.reloadData()
//        }
//    }

//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        self.searchBarActive = false
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        self.searchBarActive = false
//        DispatchQueue.main.async{
//            self.collectionView.reloadData()

    

    @objc func didTapToggle(_ sender: UIButton) {
        if changeView {
            changeView = false
            
        } else {
            changeView = true
        }
        collectionView.performBatchUpdates(nil, completion: nil)
    }
}

extension PokedexVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return filteredPokemons!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCell.reuseIdentifier, for: indexPath) as! PokeCell

        cell.pokeUrl = filteredPokemons![indexPath.item].imageUrlLarge
        cell.pokeName = filteredPokemons![indexPath.item].name
        cell.pokeID = filteredPokemons![indexPath.item].id
        cell.delegate = self
        cell.pokeTag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            if changeView {
                
                layout.minimumInteritemSpacing = 80
                return CGSize(width: 300, height: 200)

                
            } else {
                layout.minimumInteritemSpacing = 40
                return CGSize(width: (self.collectionView.frame.size.width-90) / 2, height: 200)

            }
        }
    
    func showAlert(pokeTag: Int) {
        let vc = PokemonProfileVC(pokeTag: pokeTag)
        present(vc, animated: true, completion: nil)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 40)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let cell = co
//    }

//    func collectionView(_collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        passPokemon = pokemons[indexPath.item]
//        performSegue(withIdentifier: "Pokemon Profile VC", sender: self)
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "Pokemon Profile VC" {
//            let vc = segue.destination as? PokemonProfileVC
//            vc?.currPokemon = passPokemon!
//        }
//    }
    
    

}

extension PokedexVC: UISearchBarDelegate {
    
    
    func searchBar(_searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.count > 0 {
//            self.searchBarActive = true
//            self.filterContentForSearchText(searchText: searchText)
//            self.collectionView.reloadData()
//            print(searchText)
//        } else {
//            self.searchBarActive = false
//            self.collectionView.reloadData()
//        }
//
        filteredPokemons = pokemons.filter({ pokemon in pokemon.name.contains(searchText)})
        
//        if filteredPokemons?.count == 0 {
//            filteredPokemons = pokemons
//        }
        
        if (selectedType != "None") {
            filteredPokemons = filteredPokemons?.filter({ pokemon in
                for type in pokemon.types {
                    if type.rawValue == selectedType {
                        return true
                    }
                }
                return false
            })
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()

        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            //filter even more based on original string
            selectedType = types[selectedScope]
            if (selectedType == "None") {
                filteredPokemons = pokemons
            } else {
                var newPokemons: [Pokemon] = []
                for pokemon in pokemons {
                    for type in pokemon.types {
                        if (type.rawValue == selectedType) {
                            newPokemons.append(pokemon)
                        }
                    }
                }
                
                filteredPokemons = newPokemons
            }
            collectionView.reloadData()
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
        contentView.backgroundColor = .white

        contentView.addSubview(nameView)
        contentView.addSubview(pokeButton)
        contentView.addSubview(idView)

        
        NSLayoutConstraint.activate([
            pokeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pokeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            pokeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pokeButton.bottomAnchor.constraint(equalTo: nameView.topAnchor, constant: -7),
            pokeButton.heightAnchor.constraint(equalToConstant: 100),
            nameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameView.bottomAnchor.constraint(equalTo: idView.topAnchor),
            idView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            idView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        pokeButton.addTarget(self, action: #selector(didTapPokemon(_:)), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    @objc func didTapPokemon(_ sender: UIButton) {
        let vc = PokemonProfileVC(pokeTag: sender.tag)
        print(String(sender.tag))
        self.window!.rootViewController!.present(vc, animated: true, completion: nil)
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
