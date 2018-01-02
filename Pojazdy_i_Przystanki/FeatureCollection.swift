//
//  FeatureCollection.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 25/12/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation
import SwiftyJSON

final class FeatureCollection: GeoJSONDecodable {
    private (set) var features: [GeoJSON] = []

    public init?(json: JSON) {
        guard let jsonFeatures = json.array else { return nil }

        features = jsonFeatures.flatMap { jsonObject in
            return GeoJSON(json: jsonObject)
        }

        let validFeatures = features.filter { geoJSON in
            return geoJSON.type == .feature
        }

        if validFeatures.count != features.count {
            return nil
        }
    }
    
    public var prefix: String { return "" }
}

extension FeatureCollection {
    public var count: Int { return features.count }

    public subscript(index: Int) -> GeoJSON {
        get { return features[index] }
        set(newValue) { features[index] = newValue }
    }
}

extension GeoJSON {
    public var featureCollection: FeatureCollection? {
        get {
            guard case GeoJSONType.featureCollection = self.type else { return nil }
            return object as? FeatureCollection
        }
        set {
            object = newValue ?? NSNull()
        }
    }
}
