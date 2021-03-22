// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MapKit
import UIKit

extension Router {
    public func canNavigate(
        to map: Map
    ) -> Bool {
        switch map {
        case .apple:
            return true
        default:
            guard let mapUrl = URL(string: "\(map.rawValue)://") else {
                return false
            }

            return UIApplication.shared.canOpenURL(
                mapUrl
            )
        }
    }

    public func navigateToMap(
        _ map: Map,
        for destination: (coordinate: CLLocationCoordinate2D, name: String?),
        withDirectionsFrom source: CLLocationCoordinate2D? = nil
    ) {
        switch map {
        case .apple:
            navigateToAppleMaps(
                for: destination,
                withDirectionsFrom: source
            )
        case .googlemaps:
            navigateToGoogleMaps(
                for: destination,
                withDirectionsFrom: source
            )
        case .yandex:
            navigateToYandexMaps(
                for: destination,
                withDirectionsFrom: source
            )
        case .waze:
            navigateToWazeMaps(
                for: destination,
                withDirectionsFrom: source
            )
        }
    }

    private func navigateToAppleMaps(
        for destination: (coordinate: CLLocationCoordinate2D, name: String?),
        withDirectionsFrom source: CLLocationCoordinate2D? = nil
    ) {
        var mapItems: [MKMapItem] = []

        if let source = source {
            let srcMapItem = MKMapItem(placemark: MKPlacemark(coordinate: source))

            mapItems.append(
                srcMapItem
            )
        }

        let destMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate))
        destMapItem.name = destination.name

        mapItems.append(
            destMapItem
        )

        MKMapItem.openMaps(
            with: mapItems,
            launchOptions: [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
            ]
        )
    }

    private func navigateToGoogleMaps(
        for destination: (coordinate: CLLocationCoordinate2D, name: String?),
        withDirectionsFrom source: CLLocationCoordinate2D? = nil
    ) {
        let srcQuery =
            source.unwrap(
                {
                    "\($0.latitude),\($0.longitude)"
                },
                or: ""
            )
        let destQuery =
            "\(destination.coordinate.latitude),\(destination.coordinate.longitude)"
        let urlString =
            "\(Map.googlemaps.rawValue)://?saddr=\(srcQuery)&daddr=\(destQuery)"

        guard let url = URL(string: urlString) else {
            return
        }

        UIApplication.shared.open(
            url
        )
    }

    private func navigateToYandexMaps(
        for destination: (coordinate: CLLocationCoordinate2D, name: String?),
        withDirectionsFrom source: CLLocationCoordinate2D? = nil
    ) {
        let destQuery = "\(destination.coordinate.latitude),\(destination.coordinate.longitude)"
        let urlString: String

        if let source = source {
            let srcQuery = "\(source.latitude),\(source.longitude)"
            urlString = "\(Map.yandex.rawValue)://maps.yandex.com/?rtext=\(srcQuery)~\(destQuery)"
        } else {
            urlString = "\(Map.yandex.rawValue)://maps.yandex.com/?pt=\(destQuery)"
        }

        guard let url = URL(string: urlString) else {
            return
        }

        UIApplication.shared.open(
            url
        )
    }

    private func navigateToWazeMaps(
        for destination: (coordinate: CLLocationCoordinate2D, name: String?),
        withDirectionsFrom source: CLLocationCoordinate2D? = nil
    ) {
        let destQuery = "\(destination.coordinate.latitude),\(destination.coordinate.longitude)"
        let urlString =
            "https:\\waze.com/ul/?ll=\(destQuery)&navigate=yes"

        guard let url = URL(string: urlString) else {
            return
        }

        UIApplication.shared.open(
            url
        )
    }
}

public enum Map: String {
    case apple = "apple"
    case googlemaps = "comgooglemaps"
    case yandex = "yandexmaps"
    case waze = "waze"
}
