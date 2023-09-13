//
//  UnderlineSegmentedControl.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/12.
//

import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {
    private lazy var underlineView: UIView = {
        let width = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let height = 4.0
        let xPosition = CGFloat(self.selectedSegmentIndex * Int(width))
        let yPosition = self.bounds.size.height - 2.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = .mainPink
        self.addSubview(view)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        removeBackgroundAndDivider()
    }

    override init(items: [Any]?) {
        super.init(items: items)
        removeBackgroundAndDivider()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func removeBackgroundAndDivider() {
        let image = UIImage()
        setBackgroundImage(image, for: .normal, barMetrics: .default)
        setBackgroundImage(image, for: .selected, barMetrics: .default)
        setBackgroundImage(image, for: .highlighted, barMetrics: .default)

        setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let underlineFinalXPosition = (bounds.width / CGFloat(numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.underlineView.frame.origin.x = underlineFinalXPosition
            }
        )
    }
}
