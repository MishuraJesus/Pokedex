//
//  Pokemon.swift
//  Pokedex
//
//  Created by MikhailB on 15/05/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _pokemonURL: String!
    
    var description: String {
        
        if _defense != nil {
            
            return defense
        } else {
            
            return ""
        }
    }
    
    var type: String {
        
        if _type != nil {
            
            return _type
        } else {
            
            return ""
        }
    }
    
    var defense: String {
        
        if _defense != nil {
            
            return _defense
        } else {
            
            return ""
        }
    }
    
    var height: String {
        
        if _height != nil {
            
            return _height
        } else {
            
            return ""
        }
    }
    
    var weight: String {
        
        if _weight != nil {
            
            return _weight
        } else {
            
            return ""
        }
    }
    
    var attack: String {
        
        if _attack != nil {
            
            return _attack
        } else {
            
            return ""
        }
    }
    
    var nextEvolutionText: String {
        
        if _nextEvolutionText != nil {
            
            return _nextEvolutionText
        } else {
            
            return ""
        }
    }
    
    var name: String {
        
        return _name
        
    }
    
    var pokedexId: Int {
        
        return _pokedexId
        
    }
    
    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = URL_BASE + URL_POKEMON + "\(self.pokedexId)/"
        
    }
    
    func downloadPokemonDetail(comleted: @escaping downloadComplete) {
        
        Alamofire.request(self._pokemonURL).responseJSON { response in
            
            if let JSON = response.result.value {
                
                if let dict = JSON as? Dictionary<String, AnyObject> {
                    
                    if let weight = dict["weight"] as? String {
                        
                        self._weight = weight
                    }
                    
                    if let height = dict["height"] as? String {
                        
                        self._height = height
                    }
                    
                    if let attack = dict["attack"] as? Int {
                        
                        self._attack  = "\(attack)"
                    }
                    
                    if let defense = dict["defense"] as? Int {
                        
                        self._defense = "\(defense)"
                    }
                    
                    
                }
                
                comleted()
            }
        }
    }
    
}
