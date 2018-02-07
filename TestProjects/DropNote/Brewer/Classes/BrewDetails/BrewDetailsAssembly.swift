//
//  BrewDetailsAssembly.swift
//  Brewer
//
//  Created by Maciej Oczko on 28.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject

final class BrewDetailsAssembly: AssemblyType {
	func assemble(container: Container) {
        
        container.registerForStoryboard(BrewDetailsViewController.self) {
            r, c in
            c.themeConfiguration = r.resolve(ThemeConfiguration.self)
            c.resolver = r
        }

		container.register(BrewDetailsViewModelType.self) {
			(r, brew: Brew) in
			BrewDetailsViewModel(brewModelController: r.resolve(BrewModelControllerType.self, argument: brew)!,
								 spotlightSearchService: r.resolve(SpotlightSearchService.self)!)
		}
	}
}
