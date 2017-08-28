//
//  YoshiEnvironmentMenu.swift
//  Yoshi
//
//  Created by Kanglei Fang on 28/08/2017.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

public class YoshiEnvironmentMenu: YoshiSingleSelectionMenu {
    
    init(title: String = "Environment", environmentManager: YoshiEnvironmentManager) {
        super.init(title: title,
                   options: environmentManager.environments.map { YoshiSingleSelection(title: $0.name,
                                                                                       subtitle: $0.baseURL.absoluteString)},
                   selectedIndex: environmentManager.environments.enumerated().reduce (0, { origSelection, env in
                    env.element.baseURL == environmentManager.currentEnvironment.baseURL ? env.offset : origSelection
                   }),
                   didSelect: { selection in
                    guard let selectedEnvironment = environmentManager.environments.filter ({
                        $0.baseURL.absoluteString == selection.subtitle
                    }).first else {
                        return
                    }
                    environmentManager.currentEnvironment = selectedEnvironment
        })
    }
}