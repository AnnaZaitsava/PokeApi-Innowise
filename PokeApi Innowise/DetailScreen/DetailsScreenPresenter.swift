//
//  DetailsScreenPresenter.swift
//  PokeApi Innowise
//
//  Created by Anna Zaitsava on 17.02.24.

import UIKit

protocol DetailedPresentationLogic {
    func presentDetailedInformation(response: DetailsScreenDataFlow.Info.Response)
}

class DetailsScreenPresenter: DetailedPresentationLogic {
    weak var viewController: DetailsDisplayLogic?
    
    func presentDetailedInformation(response: DetailsScreenDataFlow.Info.Response) {
        let height = "\(response.height * 10) cm"
        let weight = "\(response.weight / 10) kg"
        let typesString = response.types.map { $0.type.name }.joined(separator: ", ")
        
        if let image = UIImage(data: response.sprites) {
            let viewModel = DetailsScreenDataFlow.Info.ViewModel(
                name: response.name,
                height: height,
                weight: weight,
                types: typesString,
                sprites: image
            )
            viewController?.displayData(viewModel: viewModel)
        } else {
            print("Failed to convert image")
        }
    }
}



