// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import MacaroonVendors
import Mixpanel

open class MixpanelAnalyticsProvider: AnalyticsProvider {
    public let config: MixpanelConfig

    public init(
        config: MixpanelConfig
    ) {
        self.config = config
        commonInit()
    }

    public required init(
        nilLiteral: ()
    ) {
        self.config = MixpanelConfig(apiToken: "")
        commonInit()
    }

    private func commonInit() {
        initialize()
    }

    open func setup() {}

    open func identify<T: AnalyticsUser>(
        _ user: T
    ) {
        let instance = Mixpanel.mainInstance()
        instance.createAlias(user.id, distinctId: instance.distinctId)
        instance.identify(distinctId: instance.distinctId)
    }

    open func update<T: AnalyticsUser>(
        _ user: T
    ) {
        let instance = Mixpanel.mainInstance()
        instance.identify(distinctId: instance.distinctId)
    }

    open func canTrack<T: AnalyticsScreen>(
        _ screen: T
    ) -> Bool {
        return config.validate()
    }

    open func track<T: AnalyticsScreen>(
        _ screen: T
    ) {
        let instance = Mixpanel.mainInstance()
        let properties = Self.transformMetadataToMixpanelProperties(screen.metadata)
        instance.track(
            event: "Screen: \(screen.name)",
            properties: properties
        )
    }

    open func canTrack<T: AnalyticsEvent>(
        _ event: T
    ) -> Bool {
        return config.validate()
    }

    open func track<T: AnalyticsEvent>(
        _ event: T
    ) {
        let instance = Mixpanel.mainInstance()
        let properties = Self.transformMetadataToMixpanelProperties(event.metadata)
        instance.track(
            event: "Event: \(event.name.rawValue)",
            properties: properties
        )
    }

    open func reset() {
        let instance = Mixpanel.mainInstance()
        instance.reset()
    }
}

extension MixpanelAnalyticsProvider {
    public static func transformMetadataToMixpanelProperties<T: AnalyticsMetadata>(
        _ metadata: T
    ) -> Properties {
        return metadata.reduce(into: [:] as Properties) {
            partialResult, elem in

            if let pValue = elem.value as? Properties.Value {
                partialResult[elem.key.rawValue] = pValue
            }
        }
    }
}

extension MixpanelAnalyticsProvider {
    private func initialize() {
        if !config.validate() { return }

        Mixpanel.initialize(token: config.apiToken)

        debug {
            Mixpanel.mainInstance().loggingEnabled = true
        }
    }
}
