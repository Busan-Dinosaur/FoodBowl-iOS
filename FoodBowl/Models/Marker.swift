//
//  Marker.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/19.
//

import UIKit

import MapKit

class Marker: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let markerImage: UIImage?

    init(
        title: String?,
        subtitle: String?,
        coordinate: CLLocationCoordinate2D,
        markerImage: UIImage?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.markerImage = markerImage

        super.init()
    }
}
