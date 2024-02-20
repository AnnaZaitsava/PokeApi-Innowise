//
//  MainScreenInteractor.swift
//  PokeApi Innowise
//
//  Created by Anna Zaitsava on 17.02.24.


import Foundation

protocol MainLogic {
    func fetchPokemons(request: MainScreenDataFlow.Pokemons.Request)
    func saveSelectedItem(pokemon: MainScreenDataFlow.Pokemons.ViewModel.PokemonList)
}

protocol MainDataStore {
    var chosenPokemon: Pokemon? { get set }
}

class MainInteractor: MainLogic, MainDataStore {
    
    var presenter: MainPresentationLogic?
    var worker: MainScreenWorker?
    
    var pokemons: [Pokemon] = []
    var chosenPokemon: Pokemon?
    private let network = Network()
    private var nextPageUrl: String?
    var realm = RealmService()
    
    // MARK: class functions
    
    

    func fetchPokemons(request: MainScreenDataFlow.Pokemons.Request) {
            let url = nextPageUrl ?? "https://pokeapi.co/api/v2/pokemon"
            fetchPokemons(next: url)
        }
        
        private func fetchPokemons(next: String) {
            network.fetchPokemonList(url: next) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let result):
                        let pokemons = result.results
                        self?.pokemons += pokemons
                        let response = MainScreenDataFlow.Pokemons.Response(next: result.next ?? "", pokemons: self?.pokemons ?? [])
                        
                        for pokemon in pokemons {
                            self?.realm.savePokemonToRealm(url: pokemon.url, name: pokemon.name) { success in
                                if success {
                                    print("Pokemon saved successfully.")
                                } else {
                                    print("Failed to save Pokemon.")
                                }
                            }
                                       }
                        self?.presenter?.presentFetchedPokemons(response: response)
                        
                        if let nextPageUrl = result.next {
                            self?.nextPageUrl = nextPageUrl
                        }
                        
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        }
    
    func saveSelectedItem(pokemon: MainScreenDataFlow.Pokemons.ViewModel.PokemonList) {
        chosenPokemon = pokemons.first { $0.url == pokemon.url }
    }
}

    
    
