// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AppDependenciesResolver: AnyObject {
    associatedtype AppDependencies

    var appDependencies: AppDependencies! { get set }

    static var shared: Self { get }
}

extension AppDependenciesResolver {
    public static func register(_ appDependencies: AppDependencies) {
        shared.appDependencies = appDependencies
    }

    public static func register<T>(
        _ appDependency: T,
        for keyPath: WritableKeyPath<AppDependencies, T>
    ) {
        shared.appDependencies[keyPath: keyPath] = appDependency
    }

    public static func resolve() -> AppDependencies {
        return shared.appDependencies
    }

    public static func resolve<T>(_ keyPath: KeyPath<AppDependencies, T>) -> T {
        return shared.appDependencies[keyPath: keyPath]
    }
}
