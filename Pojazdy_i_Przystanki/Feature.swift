//
//  Feature.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 25/12/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Feature: GeoJSONDecodable {
    public var prefix: String { return "" }
    private (set) var geometry: GeoJSON?
    private (set) var properties: JSON?
    public var identifier: String?

    public init?(json: JSON) {
        properties = json["properties"]

        let jsonGeometry = json["geometry"]

        if jsonGeometry.null != nil {
            geometry = nil
        } else {
            geometry = GeoJSON(json: jsonGeometry)
            if geometry?.isGeometry == false { return nil }
        }

        let jsonIdentifier = json["id"]
        identifier = jsonIdentifier.string
    }

    public init?(geometry: GeoJSON? = nil, properties: JSON? = nil, identifier: String? = nil) {
        if properties?.error != nil { return nil }
        if geometry?.type != .unknown { return nil }
        if geometry?.isGeometry == false { return nil }
        self.properties = properties
        self.geometry = geometry
        self.identifier = identifier
    }
}

extension GeoJSON {
    public var feature: Feature? {
        get {
            guard case GeoJSONType.feature = self.type else { return nil }
            return object as? Feature
        }
        set {
            object = newValue ?? NSNull()
        }
    }

    convenience public init(feature: Feature) {
        self.init()
        object = feature
    }
}
