//
//  YoshiEncodableEnvironmentManager.swift
//  Yoshi
//
//  Created by Kanglei Fang on 25/09/2017.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Environment selection event.
public typealias EnvironmentChangeEvent = (YoshiEnvironment) -> Void

/// A YoshiEnvironmentManager that persisit user's environment selection using NSUserDefaults.
open class YoshiPersistentEnvironmentManager: YoshiEnvironmentManager {
    
    public var currentEnvironment: YoshiEnvironment {
        didSet {
            archive(environment: currentEnvironment)
            onEnvironmentChange?(currentEnvironment)
        }
    }
    
    public private(set) var environments: [YoshiEnvironment]
    
    private static let YoshiEnvironemntKey = "YoshiEnvironment"
    
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    private var onEnvironmentChange: EnvironmentChangeEvent?
    
    /// Initialize the environement manager with the given environments.
    /// The manger will retrieve the archived environment selection from NSUserDefaults if any.
    /// Othereise the first environment will be used as the current environment.
    ///
    /// - Parameters:
    ///   - environments: Available Environments.
    ///   - onEnvironmentChange: Callback when environment is changed.
    ///                          Notice that the callback will be invoked when the manager is initialized.
    public init(environments: [YoshiEnvironment], onEnvironmentChange: EnvironmentChangeEvent?) {
        self.environments = environments
        self.onEnvironmentChange = onEnvironmentChange
        if let archivedEnvironment = YoshiPersistentEnvironmentManager.archivedEnvironment,
            environments.contains(where: { $0 == archivedEnvironment }) {
            currentEnvironment = archivedEnvironment
        } else {
            guard let defaultEnvironment = environments.first else {
                fatalError("YoshiPersistentEnvironmentManager must be initalized with at least one environment")
            }
        
            currentEnvironment = defaultEnvironment
        }
        onEnvironmentChange?(currentEnvironment)
    }
}

private extension YoshiPersistentEnvironmentManager {
    
    class var archivedEnvironment: YoshiEnvironment? {
        guard let archived = UserDefaults.standard.data(forKey: YoshiEnvironemntKey),
            let environment = try? decoder.decode(YoshiEncodableEnvironment.self, from: archived) else {
            return nil
        }
        return environment
    }
    
    func archive(environment: YoshiEnvironment) {
        let encodableEnvironment = YoshiEncodableEnvironment(environment: currentEnvironment)
        let jsonData = try? YoshiPersistentEnvironmentManager.encoder.encode(encodableEnvironment)
        UserDefaults.standard.setValue(jsonData, forKey: YoshiPersistentEnvironmentManager.YoshiEnvironemntKey)
        UserDefaults.standard.synchronize()
    }
}
