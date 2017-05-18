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
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var nextEvolutionID: String {
        
        if _nextEvolutionID != nil {
            
            return _nextEvolutionID
        } else {
            
            return ""
        }
    }
    
    var nextEvolutionLevel: String {
        
        if _nextEvolutionLevel != nil {
            
            return _nextEvolutionLevel
        } else {
            
            return ""
        }
    }
    
    var nextEvolutionName: String {
        
        if _nextEvolutionName != nil {
            
            return _nextEvolutionName
        } else {
            
            return ""
        }
    }
    
    var description: String {
        
        if _description != nil {
            
            return _description
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
                    
                    if let types = dict["types"] as? Array<Dictionary<String, String>>, types.count > 0  {
                        
                        if let name = types[0]["name"] {
                            
                            self._type = name.capitalized
                        }
                        
                        if types.count > 1 {
                            
                            for x in 1..<types.count {
                                
                                if let name = types[x]["name"] {
                                    
                                    self._type! += "/\(name.capitalized)"
                                }
                            }
                        }
                        
                    } else {
                        
                        self._type = ""
                    }
                    
                    if let descriptionArray = dict["descriptions"] as? Array<Dictionary<String, String>>, descriptionArray.count > 0 {
                        if let url = descriptionArray[0]["resource_uri"] {
                            let descriptionURl = URL_BASE + url
                            
                            
                            Alamofire.request(descriptionURl).responseJSON { response in
                                
                                if let descriptionDict = response.result.value as? Dictionary<String, AnyObject> {
                                    
                                    if let pokemonDescription = descriptionDict["description"] as? String {
                                        
                                        let newDescription = pokemonDescription.replacingOccurrences(of: "POKMON", with: "Pokemon").replacingOccurrences(of: "POKEMON", with: "Pokemon").lowercased()

                                        self._description = newDescription.capitalized
                                        
                                    }
                                }
                                comleted()
                            }
                        }
                    } else {
                        
                        self._description = ""
                    }
                    
                    if let evolutionArray = dict["evolutions"] as? Array<Dictionary<String, AnyObject>>, evolutionArray.count > 0 {
                        
                        if let nextEvo = evolutionArray[0]["to"] as? String {
                            
                            if nextEvo.range(of: "mega") == nil {
                                
                                self._nextEvolutionName = nextEvo
                                
                                if let uri = evolutionArray[0]["resource_uri"] as? String {
                                    
                                    let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                    
                                    let nextEvoID = newStr.replacingOccurrences(of: "/", with: "")
                                    
                                    self._nextEvolutionID = nextEvoID
                                    
                                    if let lvlExist = evolutionArray[0]["level"] {
                                        
                                        if let level = lvlExist as? Int {
                                            
                                            self._nextEvolutionLevel = "\(level)"
                                        }
                                    } else {
                                        
                                        self._nextEvolutionLevel = ""
                                    }
                                }
                            }
                        }
                    }
                    print(self.nextEvolutionID)
                    print(self.nextEvolutionLevel)
                    print(self.nextEvolutionName)
                }
                
            }
            comleted()
        }
    }

}
