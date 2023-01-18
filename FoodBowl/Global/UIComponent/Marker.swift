//
//  Marker.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/19.
//

import MapKit

class Marker: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?

    init(
        title: String?,
        subtitle: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate

        super.init()
    }
}
