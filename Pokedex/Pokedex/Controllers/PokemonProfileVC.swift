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
        
        let pokeImage = UIImageView(frame: CGRect(x:50, y: 70, width: 200, height: 200))
        let Url: URL = URL(string: currPokemon.imageUrlLarge)!
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData: NSData = NSData(contentsOf: Url)!
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                pokeImage.image = image
            }
        }
        view.addSubview(pokeImage)
        
        let typeLabel = UILabel(frame: CGRect(x: 20, y: 270, width: view.frame.width * 0.8, height: 20))
//        typeLabel.text = currPokemon.types
        
//        var text = ""
//        for type in currPokemon.types {
//            text += String(type) + " "
//        }
//        typeLabel.text = text
        
        
        
        let attackLabel = UILabel(frame: CGRect(x: 20, y: 290, width: view.frame.width * 0.8, height: 20))
        attackLabel.text = "Attack: \(String(currPokemon.attack))"
        view.addSubview(attackLabel)
        
        let defenseLabel = UILabel(frame: CGRect(x: 20, y: 310, width: view.frame.width * 0.8, height: 20))
        defenseLabel.text = "Defense: \(String(currPokemon.defense))"
        view.addSubview(defenseLabel)

        let healthLabel = UILabel(frame: CGRect(x: 20, y: 330, width: view.frame.width * 0.8, height: 20))
        healthLabel.text = "Health: \(String(currPokemon.health))"
        view.addSubview(healthLabel)

        let spAttackLabel = UILabel(frame: CGRect(x: 20, y: 350, width: view.frame.width * 0.8, height: 20))
        spAttackLabel.text = "Special Attack: \(String(currPokemon.specialAttack))"
        view.addSubview(spAttackLabel)

        let spDefenseLabel = UILabel(frame: CGRect(x: 20, y: 370, width: view.frame.width * 0.8, height: 20))
        spDefenseLabel.text = "Special Defense: \(String(currPokemon.specialDefense))"
        view.addSubview(spDefenseLabel)
        
        let speedLabel = UILabel(frame: CGRect(x: 20, y: 390, width: view.frame.width * 0.8, height: 20))
        speedLabel.text = "Speed: \(String(currPokemon.speed))"
        view.addSubview(speedLabel)
        
        let totalLabel = UILabel(frame: CGRect(x: 20, y: 410, width: view.frame.width * 0.8, height: 20))
        totalLabel.text = "Total: \(String(currPokemon.total))"
        view.addSubview(totalLabel)
        



    }
    
    @objc func didTapBack(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
