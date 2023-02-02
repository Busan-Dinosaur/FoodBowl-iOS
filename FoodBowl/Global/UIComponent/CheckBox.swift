//
//  CheckBox.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/27.
//

import UIKit

@IBDesignable
open class CheckBox: UIControl {
    /// Used to choose the style for the Checkbox
    public enum Style {
        /// ■
        case square
        /// ●
        case circle
        /// x
        case cross
        /// ✓
        case tick
    }

    /// Shape of the outside box containing the checkmarks contents.
    /// Used as a visual indication of where the user can tap.
    public enum BorderStyle {
        /// ▢
        case square
        /// ■
        case roundedSquare(radius: CGFloat)
        /// ◯
        case rounded
    }

    var style: Style = .circle
    var borderStyle: BorderStyle = .roundedSquare(radius: 8)

    @IBInspectable
    var borderWidth: CGFloat = 1.75

    var checkmarkSize: CGFloat = 0.5

    @IBInspectable
    var uncheckedBorderColor: UIColor = .grey001

    @IBInspectable
    var checkedBorderColor: UIColor = .grey001

    @IBInspectable
    var checkmarkColor: UIColor = .subText

    var checkboxBackgroundColor: UIColor = .grey001

    // Used to increase the touchable are for the component
    var increasedTouchRadius: CGFloat = 5

    // By default it is true
    var useHapticFeedback = true

    @IBInspectable
    var isChecked = false {
        didSet {
            setNeedsDisplay()
        }
    }

    // UIImpactFeedbackGenerator object to wake up the device engine to provide feed backs
    private var feedbackGenerator: UIImpactFeedbackGenerator?

    // MARK: Intialisers

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = .clear
    }

    // Define the above UIImpactFeedbackGenerator object, and prepare the engine to be ready to provide feedback.
    // To store the energy and as per the best practices, we create and make it ready on touches begin.
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator?.prepare()
    }

    // On touches ended,
    // change the selected state of the component, and changing *isChecked* property, draw methos will be called
    // So components appearance will be changed accordingly
    // Hence the state change occures here, we also sent notification for value changed event for this component.
    // After usage of feedback generator object, we make it nill.
    override open func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        //        super.touchesEnded(touches, with: event)

        isChecked = !isChecked
        sendActions(for: .valueChanged)
        if useHapticFeedback {
            feedbackGenerator?.impactOccurred()
            feedbackGenerator = nil
        }
    }

    override open func draw(_ rect: CGRect) {
        // Draw the outlined component
        let newRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)

        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(checkedBorderColor.cgColor)
        context.setFillColor(checkboxBackgroundColor.cgColor)
        context.setLineWidth(borderWidth)

        var shapePath: UIBezierPath!
        switch borderStyle {
        case .square:
            shapePath = UIBezierPath(rect: newRect)
        case .roundedSquare(let radius):
            shapePath = UIBezierPath(roundedRect: newRect, cornerRadius: radius)
        case .rounded:
            shapePath = UIBezierPath(ovalIn: newRect)
        }

        context.addPath(shapePath.cgPath)
        context.strokePath()
        context.fillPath()

        // When it is selected, depends on the style
        // By using helper methods, draw the inner part of the component UI.
        if isChecked {
            switch style {
            case .square:
                drawInnerSquare(frame: newRect)
            case .circle:
                drawCircle(frame: newRect)
            case .cross:
                drawCross(frame: newRect)
            case .tick:
                drawCheckMark(frame: newRect)
            }
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setNeedsDisplay()
    }

    // we override the following method,
    // To increase the hit frame for this component
    // Usaully check boxes are small in our app's UI, so we need more touchable area for its interaction
    override open func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        let relativeFrame = bounds
        let hitTestEdgeInsets = UIEdgeInsets(
            top: -increasedTouchRadius,
            left: -increasedTouchRadius,
            bottom: -increasedTouchRadius,
            right: -increasedTouchRadius
        )
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }

    // Draws tick inside the component
    func drawCheckMark(frame: CGRect) {
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.50000 * frame.height))
        bezierPath.addCurve(
            to: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height),
            controlPoint1: CGPoint(x: frame.minX + 0.38000 * frame.width, y: frame.minY + 0.60000 * frame.height),
            controlPoint2: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height)
        )
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.70000 * frame.width, y: frame.minY + 0.24000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.78000 * frame.width, y: frame.minY + 0.30000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height))
        bezierPath.addCurve(
            to: CGPoint(x: frame.minX + 0.20000 * frame.width, y: frame.minY + 0.58000 * frame.height),
            controlPoint1: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height),
            controlPoint2: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.62000 * frame.height)
        )
        checkmarkColor.setFill()
        bezierPath.fill()
    }

    // Draws circle inside the component
    func drawCircle(frame: CGRect) {
        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ fast: CGFloat) -> CGFloat { return floor(fast) }

        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(
            x: frame.minX + fastFloor(frame.width * 0.22000 + 0.5),
            y: frame.minY + fastFloor(frame.height * 0.22000 + 0.5),
            width: fastFloor(frame.width * 0.76000 + 0.5) - fastFloor(frame.width * 0.22000 + 0.5),
            height: fastFloor(frame.height * 0.78000 + 0.5) - fastFloor(frame.height * 0.22000 + 0.5)
        ))
        checkmarkColor.setFill()
        ovalPath.fill()
    }

    // Draws square inside the component
    func drawInnerSquare(frame: CGRect) {
        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ fast: CGFloat) -> CGFloat { return floor(fast) }

        //// Rectangle Drawing
        let padding = bounds.width * 0.3
        let innerRect = frame.inset(by: .init(top: padding, left: padding, bottom: padding, right: padding))
        let rectanglePath = UIBezierPath(roundedRect: innerRect, cornerRadius: 3)

        checkmarkColor.setFill()
        rectanglePath.fill()
    }

    // Draws cross inside the component
    func drawCross(frame: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ fast: CGFloat) -> CGFloat { return floor(fast) }

        //// Subframes
        let group = CGRect(
            x: frame.minX + fastFloor((frame.width - 17.37) * 0.49035 + 0.5),
            y: frame.minY + fastFloor((frame.height - 23.02) * 0.51819 - 0.48) + 0.98, width: 17.37, height: 23.02
        )

        //// Group
        //// Rectangle Drawing
        context.saveGState()
        context.translateBy(x: group.minX + 14.91, y: group.minY)
        context.rotate(by: 35 * CGFloat.pi / 180)

        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 3, height: 26))
        checkmarkColor.setFill()
        rectanglePath.fill()

        context.restoreGState()

        //// Rectangle 2 Drawing
        context.saveGState()
        context.translateBy(x: group.minX, y: group.minY + 1.72)
        context.rotate(by: -35 * CGFloat.pi / 180)

        let rectangle2Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 3, height: 26))
        checkmarkColor.setFill()
        rectangle2Path.fill()

        context.restoreGState()
    }
}
