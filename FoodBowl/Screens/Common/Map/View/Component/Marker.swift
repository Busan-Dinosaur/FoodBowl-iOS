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
    let glyphImage: UIImage?
    let handler: () -> Void?

    init(
        title: String?,
        subtitle: String?,
        coordinate: CLLocationCoordinate2D,
        glyphImage: UIImage?,
        handler: @escaping () -> Void?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.glyphImage = glyphImage
        self.handler = handler

        super.init()
    }
}

class CustomMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let marker = newValue as? Marker else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            
            // Title 설정 및 폰트 크기 변경
            if let title = marker.title {
                let titleView = UILabel()
                titleView.text = title
                titleView.font = UIFont.boldSystemFont(ofSize: 16.0) // 원하는 폰트 크기로 변경
                detailCalloutAccessoryView = titleView
            }
            
            // Subtitle 설정 및 폰트 크기 변경
            if let subtitle = marker.subtitle {
                let subtitleView = UILabel()
                subtitleView.text = subtitle
                subtitleView.font = UIFont.systemFont(ofSize: 14.0) // 원하는 폰트 크기로 변경
                detailCalloutAccessoryView = subtitleView
            }
            
            // 기타 설정...
        }
    }
}
