//
//  StoreMarkerView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/28.
//

import UIKit

import MapKit

class StoreMarkerView: MKMarkerAnnotationView {
    let feedButton = FeedButton()

    override var annotation: MKAnnotation? {
        willSet {
            guard let marker = newValue as? Marker else { return }

            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = feedButton
            markerTintColor = UIColor.mainPink
            glyphImage = marker.glyphImage
        }
    }
}
