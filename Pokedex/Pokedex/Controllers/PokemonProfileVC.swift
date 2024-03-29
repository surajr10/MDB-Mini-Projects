//
//  PokemonProfileVC.swift
//  Pokedex
//
//  Created by Suraj Rao on 3/5/21.
//

import Foundation
import UIKit

class PokemonProfileVC: UIViewController {
    
    let pokemons = PokemonGenerator.shared.getPokemonArray()
    
    var currPokemon: Pokemon
    
    init(pokeTag: Int) {
        currPokemon = pokemons[pokeTag]
//        currPokemon = passedPokemon
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            backButton.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100)
        ])
        
        backButton.addTarget(self, action: #selector(didTapBack(_:)), for: .touchUpInside)
        
        let pokeImage = UIImageView(frame: CGRect(x:100, y: 70, width: 200, height: 200))
        let Url: URL = URL(string: currPokemon.imageUrlLarge)!
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData: NSData = NSData(contentsOf: Url)!
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                pokeImage.image = image
            }
        }
        view.addSubview(pokeImage)
        
        let nameLabel = UILabel(frame: CGRect(x: 110, y: 270, width: view.frame.width * 0.8, height: 20))
        nameLabel.text = "Name: \(String(currPokemon.name))"
        nameLabel.font.withSize(25)
        view.addSubview(nameLabel)
        
        let idLabel = UILabel(frame: CGRect(x: 110, y: 290, width: view.frame.width * 0.8, height: 20))
        idLabel.text = "ID: \(String(currPokemon.id))"
        view.addSubview(idLabel)
        
        var typeText: String = ""
        
        for type in currPokemon.types {
                switch type {
                case .Bug:
                    typeText += "Bug, "
                case .Grass:
                    typeText += "Grass, "
                case .Dark:
                    typeText += "Dark, "
                case .Ground:
                    typeText += "Ground, "
                case .Dragon:
                    typeText += "Dragon, "
                case .Ice:
                    typeText += "Ice, "
                case .Electric:
                    typeText += "Electric, "
                case .Normal:
                    typeText += "Normal, "
                case .Fairy:
                    typeText += "Fairy, "
                case .Poison:
                    typeText += "Poison, "
                case .Fighting:
                    typeText += "Fighting, "
                case .Psychic:
                    typeText += "Psychic, "
                case .Fire:
                    typeText += "Fire, "
                case .Rock:
                    typeText += "Rock, "
                case .Flying:
                    typeText += "Flying, "
                case .Steel:
                    typeText += "Steel, "
                case .Ghost:
                    typeText += "Ghsot, "
                case .Water:
                    typeText += "Water, "
                case .Unknown:
                    typeText += "Unknown, "
                }
        }

        
        let typeLabel = UILabel(frame: CGRect(x: 110, y: 310, width: view.frame.width * 0.8, height: 20))
        typeLabel.text = "Types: \(typeText)"
        view.addSubview(typeLabel)
        
        
//        typeLabel.text = currPokemon.types
        
//        var text = ""
//        for type in currPokemon.types {
//            text += String(type) + " "
//        }
//        typeLabel.text = text
        
        
        
        let attackLabel = UILabel(frame: CGRect(x: 110, y: 330, width: view.frame.width * 0.8, height: 20))
        attackLabel.text = "Attack: \(String(currPokemon.attack))"
        view.addSubview(attackLabel)
        
        let defenseLabel = UILabel(frame: CGRect(x: 110, y: 350, width: view.frame.width * 0.8, height: 20))
        defenseLabel.text = "Defense: \(String(currPokemon.defense))"
        view.addSubview(defenseLabel)

        let healthLabel = UILabel(frame: CGRect(x: 110, y: 370, width: view.frame.width * 0.8, height: 20))
        healthLabel.text = "Health: \(String(currPokemon.health))"
        view.addSubview(healthLabel)

        let spAttackLabel = UILabel(frame: CGRect(x: 110, y: 390, width: view.frame.width * 0.8, height: 20))
        spAttackLabel.text = "Special Attack: \(String(currPokemon.specialAttack))"
        view.addSubview(spAttackLabel)

        let spDefenseLabel = UILabel(frame: CGRect(x: 110, y: 410, width: view.frame.width * 0.8, height: 20))
        spDefenseLabel.text = "Special Defense: \(String(currPokemon.specialDefense))"
        view.addSubview(spDefenseLabel)
        
        let speedLabel = UILabel(frame: CGRect(x: 110, y: 430, width: view.frame.width * 0.8, height: 20))
        speedLabel.text = "Speed: \(String(currPokemon.speed))"
        view.addSubview(speedLabel)
        
        let totalLabel = UILabel(frame: CGRect(x: 110, y: 450, width: view.frame.width * 0.8, height: 20))
        totalLabel.text = "Total: \(String(currPokemon.total))"
        view.addSubview(totalLabel)
        



    }
    
    @objc func didTapBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
